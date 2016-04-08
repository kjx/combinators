import "parsers2" as parsers
inherits parsers.exports 

//////////////////////////////////////////////////
// Grace Grammar

class exports {
  //BEGINGRAMMAR
  // top level
  def program = rule {codeSequence ~ rep(ws) ~ end}
  def codeSequence = rule { repdel((declaration | statement | empty), semicolon) }
  def innerCodeSequence = rule { repdel((innerDeclaration | statement | empty), semicolon) }

  // def comment = 

  // declarations

  def declaration = rule {
        varDeclaration | defDeclaration | classDeclaration |
          typeDeclaration | methodDeclaration }

  def innerDeclaration = rule { 
         varDeclaration | defDeclaration | classDeclaration | typeDeclaration }

  def varDeclaration = rule { 
          varId ~ identifier ~  opt(colon ~ typeExpression) ~ opt(assign ~ expression) }

  def defDeclaration = rule { 
          defId ~ identifier ~  opt(colon ~ typeExpression) ~ equals ~ expression }

  def methodDeclaration = rule {
          methodId ~ methodHeader ~ methodReturnType ~ whereClause ~
                             lBrace ~ innerCodeSequence ~ rBrace }
  def classDeclaration = rule {
          classId ~ identifier ~ dot ~ classHeader ~ methodReturnType ~ whereClause ~ 
                                 lBrace ~ inheritsClause ~ codeSequence ~ rBrace }

  //def oldClassDeclaration = rule { classId ~ identifier ~ lBrace ~ 
  //                             opt(genericFormals ~ blockFormals ~ arrow) ~ codeSequence ~ rBrace }


  //warning: order here is significant!
  def methodHeader = rule { accessingAssignmentMethodHeader | accessingMethodHeader | assignmentMethodHeader | methodWithArgsHeader | unaryMethodHeader | operatorMethodHeader | prefixMethodHeader  } 

  def classHeader = rule { methodWithArgsHeader | unaryMethodHeader }
  def inheritsClause = rule { opt( inheritsId ~ expression ~ semicolon ) }  

  def unaryMethodHeader = rule { identifier ~ genericFormals } 
  def methodWithArgsHeader = rule { firstArgumentHeader ~ repsep(argumentHeader,opt(ws)) }
  def firstArgumentHeader = rule { identifier ~ genericFormals ~ methodFormals }
  def argumentHeader = rule { identifier ~ methodFormals }
  def operatorMethodHeader = rule { otherOp ~ oneMethodFormal } 
  def prefixMethodHeader = rule { opt(ws) ~ token("prefix") ~ otherOp }  // forbid space after prefix?
  def assignmentMethodHeader = rule { identifier ~ assign ~ oneMethodFormal }
  def accessingMethodHeader = rule { lrBrack ~ genericFormals ~ methodFormals }
  def accessingAssignmentMethodHeader = rule { lrBrack ~ assign ~ genericFormals ~ methodFormals }

  def methodReturnType = rule { opt(arrow ~ nonEmptyTypeExpression )  } 

  def methodFormals = rule { lParen ~ rep1sep( identifier ~ opt(colon ~ opt(ws) ~ typeExpression), comma) ~ rParen}
  def oneMethodFormal = rule { lParen ~ identifier ~ opt(colon ~ typeExpression) ~ rParen}
  def blockFormals = rule { repsep( identifier ~ opt(colon ~ typeExpression), comma) }

  def matchBinding = rule{ (identifier | literal | parenExpression) ~
                             opt(colon ~ nonEmptyTypeExpression ~ opt(matchingBlockTail)) }

  def matchingBlockTail = rule { lParen ~ rep1sep(matchBinding, comma)  ~ rParen }

  def typeDeclaration = rule {
          typeId ~ identifier ~ genericFormals ~
              equals ~ nonEmptyTypeExpression ~ (semicolon | whereClause)}

  //these are the things that work - 24 July with EELCO
  def typeExpression = rule { (opt(ws) ~ typeOpExpression ~ opt(ws)) | opt(ws) }
  def nonEmptyTypeExpression = rule { opt(ws) ~ typeOpExpression ~ opt(ws) }

  //these definitely don't - 24 July with EELCO
  // def typeExpression = rule { (opt(ws) ~ expression ~ opt(ws)) | opt(ws) }
  //def nonEmptyTypeExpression = rule { opt(ws) ~ expression ~ opt(ws) }

  def typeOp = rule { opsymbol("|") | opsymbol("&") | opsymbol("+") } 

  // def typeOpExpression = rule { rep1sep(basicTypeExpression, typeOp) }

  // this complex rule ensures two different typeOps have no precedence
  def typeOpExpression = rule {  
    var otherOperator 
    basicTypeExpression ~ opt(ws) ~
      opt( guard(typeOp, { s -> otherOperator:= s;
                                true })
            ~ rep1sep(basicTypeExpression ~ opt(ws),
               guard(typeOp, { s -> s == otherOperator })
          )
      )
    } 

  def basicTypeExpression = rule { nakedTypeLiteral | literal | pathTypeExpression | parenTypeExpression }  
     // if we keep this, note that in a typeExpression context { a; } is  interpreted as type { a; }
     // otherwise as the block { a; }

  def pathTypeExpression = rule { opt(superId ~ dot) ~ rep1sep((identifier ~ genericActuals),dot) }

  def parenTypeExpression = rule { lParen ~ typeExpression ~ rParen } 



  // statements

  def statement = rule { returnStatement | (expression ~ opt(assignmentTail))  } 
      // do we need constraints here on which expressions can have an assignmentTail
      // could try to rewrite as options including (expression ~ arrayAccess ~ assignmentTail)
      // expression ~ dot ~ identifier ~ assignmentTail 

  def returnStatement = rule { returnId ~ opt(expression) }  //doesn't need parens
  def assignmentTail = rule { assign ~ expression }

  // expressions

  def expression = rule { opExpression } 

  //def opExpression = rule { rep1sep(addExpression, otherOp)}

  // this complex rule ensures two different otherOps have no precedence
  def opExpression = rule { 
    var otherOperator 
    addExpression ~ opt(ws) ~
      opt( guard(otherOp, { s -> otherOperator:= s;
                                 true }) ~ rep1sep(addExpression ~ opt(ws),
             guard(otherOp, { s -> s == otherOperator })
          )
      )
    } 

  def addExpression = rule { rep1sep(multExpression, addOp) }
  def multExpression = rule { rep1sep(prefixExpression, multOp) }
  def prefixExpression = rule { (rep(otherOp) ~ selectorExpression) | (rep1(otherOp) ~ superId) } 
        // we can have !super 

  def selectorExpression = rule { primaryExpression ~ rep(selector) }

  def selector = rule { 
                        (dot ~ unaryRequest) | 
                          (dot ~ requestWithArgs) |
                          (lBrack ~ rep1sep(expression,comma) ~ rBrack)  
                      }

  def operatorChar = characterSetParser("!?@#$%^&|~=+-*/><:.") // had to be moved up

  //special symbol for operators: cannot be followed by another operatorChar
  method opsymbol(s : String) {trim(token(s) ~ not(operatorChar))}

  def multOp = opsymbol "*" | opsymbol "/" 
  def addOp = opsymbol "+" | opsymbol "-" 
  def otherOp = rule { guard(trim(rep1(operatorChar)), { s -> ! parse(s) with( reservedOp ~ end ) })} 
      // encompasses multOp and addOp
  def operator = rule { otherOp | reservedOp }  

  def unaryRequest = rule { trim(identifier) ~ genericActuals ~ not(delimitedArgument) } 
  def requestWithArgs = rule { firstRequestArgumentClause ~ repsep(requestArgumentClause,opt(ws)) }
  def firstRequestArgumentClause = rule { identifier ~ genericActuals ~ opt(ws) ~ delimitedArgument }
  def requestArgumentClause = rule { identifier ~ opt(ws) ~ delimitedArgument }
  def delimitedArgument = rule { argumentsInParens | blockLiteral | stringLiteral }
  def argumentsInParens = rule { lParen ~ rep1sep(drop(opt(ws)) ~ expression, comma) ~ rParen  }  

  def implicitSelfRequest = rule { requestWithArgs |  rep1sep(unaryRequest,dot) }

  def primaryExpression = rule { literal | nonNakedSuper | implicitSelfRequest | parenExpression }  

  def parenExpression = rule { lParen ~ rep1sep(drop(opt(ws)) ~ expression, semicolon) ~ rParen } 
                                        // TODO should parenExpression be around a codeSequence?

  def nonNakedSuper = rule { superId ~ not(not( operator | lBrack )) }

  // "generics" 
  def genericActuals = rule { 
                              opt(lGeneric ~ opt(ws)
                               ~ rep1sep(opt(ws) ~ typeExpression ~ opt(ws),opt(ws) ~ comma ~ opt(ws))
                               ~ opt(ws) ~ rGeneric) }

  def genericFormals = rule { opt(lGeneric ~  rep1sep(identifier, comma)  ~ rGeneric) }

  def whereClause = rule { repdel(whereId ~ typePredicate, semicolon) }
  def typePredicate = rule { expression }

  //wherever genericFormals appear, there should be a whereClause nearby.


  // "literals"

  def literal = rule { stringLiteral | selfLiteral | blockLiteral | numberLiteral | 
                           objectLiteral | tupleLiteral | typeLiteral } 

  def stringLiteral = rule { opt(ws) ~ doubleQuote ~ rep( stringChar ) ~ doubleQuote ~ opt(ws) } 
  def stringChar = rule { (drop(backslash) ~ escapeChar) | anyChar | space}
  def blockLiteral = rule { lBrace ~ opt( (matchBinding | blockFormals) ~ arrow) 
                                   ~ innerCodeSequence ~ rBrace }
  def selfLiteral = symbol "self" 
  def numberLiteral = trim(digitStringParser)
  def objectLiteral = rule { objectId ~ lBrace ~ inheritsClause ~ codeSequence ~ rBrace }

  //these are *not* in the spec - EELCO 
  def tupleLiteral = rule { lBrack ~ repsep( expression, comma ) ~ rBrack }

  def typeLiteral = rule { typeId ~ opt(ws) ~ nakedTypeLiteral }

  //kernan
  def nakedTypeLiteral = rule { lBrace ~ opt(ws) ~ repdel(methodHeader ~ methodReturnType, (semicolon | whereClause)) ~ opt(ws) ~ rBrace }

  // terminals
  def backslash = token "\\"    // doesn't belong here, doesn't work if left below!
  def doubleQuote = token "\""
  def space = token " " 
  def semicolon = rule { (symbol(";") ~ opt(newLine)) | (opt(ws) ~ lineBreak("left" | "same") ~ opt(ws)) }
  def colon = rule {both(symbol ":", not(assign))}
  def newLine = symbol "\n" 
  def lParen = symbol "("
  def rParen = symbol ")" 
  def lBrace = symbol "\{"
  def rBrace = symbol "\}"
  def lBrack = symbol "["
  def rBrack = symbol "]"
  def lrBrack = symbol "[]"
  def arrow = symbol "->"
  def dot = symbol "."
  def assign = symbol ":="
  def equals = symbol "="

  def lGeneric = token "<"
  def rGeneric = token ">"

  def comma = rule { symbol(",") }
  def escapeChar = characterSetParser("\\\"'\{\}bnrtlfe ")

  def azChars = "abcdefghijklmnopqrstuvwxyz"
  def AZChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  def otherChars = "1234567890~!@#$%^&*()_-+=[]|\\:;<,>.?/"

  def anyChar = characterSetParser(azChars ++ AZChars ++ otherChars)

  def identifierString = (graceIdentifierParser ~ drop(opt(ws)))

  // def identifier = rule { bothAll(trim(identifierString),not(reservedIdentifier))  }   
                             // bothAll ensures parses take the same length
  // def identifier = rule{ both(identifierString,not(reservedIdentifier))  }   
                            // both doesn't ensure parses take the same length
  def identifier = rule { guard(identifierString, { s -> ! parse(s) with( reservedIdentifier ~ end ) })}
                          // probably works but runs out of stack

  // anything in this list needs to be in reservedIdentifier below (or it won't do what you want)
  def superId = symbol "super" 
  def extendsId = symbol "extends"
  def inheritsId = symbol "inherits"
  def classId = symbol "class" 
  def objectId = symbol "object" 
  def typeId = symbol "type" 
  def whereId = symbol "where" 
  def defId = symbol "def" 
  def varId = symbol "var" 
  def methodId = symbol "method" 
  def prefixId = symbol "prefix" 
  def interfaceId = symbol "interface"
  def returnId = symbol "return"
  //WTF is OUTER??? - EELCO July 25


  //kernan
  def reservedIdentifier = rule {selfLiteral | superId | extendsId | inheritsId | classId | objectId | typeId | whereId | returnId | defId | varId | methodId | prefixId | interfaceId } // more to come

  def reservedOp = rule {assign | equals | dot | arrow | colon | semicolon}  // this is not quite right

  //ENDGRAMMAR
}

