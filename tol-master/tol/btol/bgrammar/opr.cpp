/* opr.cpp: Implemantation functions for class BOperator
            GNU/TOL Language.

   Copyright (C) 2003 - Bayes Decision, SL (Spain [EU])

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
   USA.
 */

#if defined(_MSC_VER)
#include <win_tolinc.h>
#endif

#include <tol/tol_boper.h>
#include <tol/tol_init.h>
#include <tol/tol_bstruct.h>
#include <tol/tol_butil.h>
#include <tol/tol_bout.h>
#include <tol/tol_blanguag.h>
#include <tol/tol_bcodgra.h>

//--------------------------------------------------------------------
// INICIALIZATION
//   Global variables (static in the class BOperator).
//--------------------------------------------------------------------
BTraceInit("opr.cpp");

BList* BOperClassify::instances_ = NIL;
BArray<BAtom*> BOperClassify::sortedTheme_;
BOperClassify* BOperClassify::Various_;
BList* BOperator::pendingOperators_ = NIL;
BOperClassify* BOperClassify::General_;
BOperClassify* BOperClassify::System_;
BOperClassify* BOperClassify::Conversion_;
BOperClassify* BOperClassify::FileIncluding_;
BOperClassify* BOperClassify::SetAlgebra_;
BOperClassify* BOperClassify::Text_;
BOperClassify* BOperClassify::RealArythmetic_;
BOperClassify* BOperClassify::RealArythmetic_GSL_;
BOperClassify* BOperClassify::ComplexArythmetic_;
BOperClassify* BOperClassify::NumericalAnalysis_;
BOperClassify* BOperClassify::Logic_;
BOperClassify* BOperClassify::Statistic_;
BOperClassify* BOperClassify::Probability_;
BOperClassify* BOperClassify::Sthocastic_;
BOperClassify* BOperClassify::MatrixAlgebra_;
BOperClassify* BOperClassify::RetardPolynomial_;
BOperClassify* BOperClassify::TimeAlgebra_;
BOperClassify* BOperClassify::CalendarVariables_;
BOperClassify* BOperClassify::TimeSeriesAlgebra_;
BOperClassify* BOperClassify::TimeSeriesLogic_;
BOperClassify* BOperClassify::BayesDataBase_;
BOperClassify* BOperClassify::Extension_;
BOperClassify* BOperClassify::DataMining_;

std::vector<BUserFunction*> BUserFunction::activeFunctions_;

//--------------------------------------------------------------------
// Operators classification
//--------------------------------------------------------------------

//--------------------------------------------------------------------
BOperClassify::BOperClassify(const BText& name, const BText& desc)

/*! BOperClassify constructor
 * \param name Name of BOperClassify
 * \param desc Description of BOperClassify
 */
//--------------------------------------------------------------------
  : BObject(name), operators_(NIL), description_(desc)
{
//Std(BText("\nCreating classify operator ")+Name());
    instances_ = Cons(this, instances_);
    sortedTheme_.AddSorted(this,AtmCmp);
    IncNRefs();
    IncNRefs();
    IncNRefs();
    IncNRefs();
    IncNRefs();
}

const BText BOperClassify::Description() const { return(description_); }

//--------------------------------------------------------------------
BOperClassify* BOperClassify::Find(const BText& className)
//--------------------------------------------------------------------
{
  BOperClassify* found = NULL;
  BObjectCRef aux(className);
  int f = sortedTheme_.FindSorted(&aux,AtmCmp);
  if(f>=0) { found = (BOperClassify*)sortedTheme_[f]; }
  return(found);
}

//--------------------------------------------------------------------
void BOperClassify::Add(BSyntaxObject* opr)
/*! Adds a operator to the classify.
 */
//--------------------------------------------------------------------
{
    operators_ = Cons(opr, operators_);
    opr->DecNRefs();
}

//--------------------------------------------------------------------
void BOperClassify::Del(BSyntaxObject* opr)

/*! Removes a operator from the classify.
 */
//--------------------------------------------------------------------
{
    operators_ = LstRemoveAtom(operators_, opr);
}

//--------------------------------------------------------------------
BList* BOperClassify::Instances()
//--------------------------------------------------------------------
{
    return(instances_);
}

//--------------------------------------------------------------------
BList* BOperClassify::Operators()
//--------------------------------------------------------------------
{
    return(operators_);
}


//--------------------------------------------------------------------
void BOperClassify::InitInstances()
/*! Initializes all classifies of operators.
 */
//--------------------------------------------------------------------
{
  static BBool initInstances_ = BFALSE;
  if(initInstances_) { return; }
  initInstances_ = BTRUE;

Various_ = new BOperClassify
(
  I2("Various","Varios"),
  I2("Unclassified functions."
     ,
     "Funciones sin clasificar.")
);
General_ = new BOperClassify
(
  I2("Generic","Generales"),
  I2("Functions that, or well they do not return any object, or well they "
     "can return objects of any type depending on the context."
     ,
     "Funciones que, o bien no devuelven ning�n objeto, o bien pueden "
     "devolver objetos de cualquier tipo dependiendo del contexto.")
);
System_ = new BOperClassify
(
  I2("System","Sistema"),
  I2("Functions related to the system as reading and files writing, date "
     "and hour, etc."
     ,
     "Funciones relacionadas con el sistema como lectura y escritura de "
     "ficheros, fecha y hora, etc.")
);
Conversion_ = new BOperClassify
(
  I2("Conversion",
     "Conversi�n"),
  I2("Functions for the conversion of some types of data or of some of its "
     "parts in other objects or parts of they.",
     "Funciones para la conversi�n de unos tipos de datos o de alguna de sus "
     "partes en otros objetos o partes de ellos.")
);
FileIncluding_ = new BOperClassify
(
  I2("Files Including","Inclusi�n de Ficheros"),
  I2("Functions to include legible files by TOL. With them can be loaded "
     "data with primary series, data matrixs and all type with structured "
     "information"
     ,
     "Funciones para incluir ficheros legibles por TOL. Con ellas se puede "
     "cargar datos de series primarias, matrices de datos y todo tipo de "
     "informaci�n estructurada.")
);
SetAlgebra_ = new BOperClassify
(
  I2("Set's Algebra",
     "�lgebra de Conjuntos"),
  I2("Sum, intersection and sets subtraction as well as other functions that "
     "permits the sets managing or the access and process of its elements."
     ,
     "Suma, intersecci�n y resta de conjuntos as� como otras funciones que "
     "permiten el manejo de conjuntos o el acceso y proceso de sus "
     "elementos.")
);
Text_ = new BOperClassify
(
  I2("Text Management","Manejo de Texto"),
  I2("Typical process functions of texts as search, attachment, extraction "
     "of subchains, etc."
     ,
     "Funciones t�picas de proceso de textos como b�squeda, concatenaci�n, "
     "extracci�n de subcadenas, etc.")
);
RealArythmetic_ = new BOperClassify
(
  I2("Real Arthymetic",
     "Aritm�tica Real"),
  I2("Real function arithmetic, logarithms, exponential, trigonometrical, "
     "hyperbolic, etc. When an operation is accomplished would be of the "
     "adequate domain, for example 1/0, is returned the value done not know "
     "( written as the character ? ). also, any operation of real in the one "
     "which appear a value done not know will return also the value done not "
     "know."
     ,
     "Funciones reales aritm�ticas, logaritmos, exponenciales, "
     "trigonom�tricas, hiperb�licas, etc. Cuando una operaci�n se realiza "
     "fuera del dominio adecuado, por ejemplo 1/0, se devuelve el valor "
     "desconocido ( escrito como el car�cter ? ). As� mismo, cualquier "
     "operaci�n de reales en la que aparezca un valor desconocido devolver� "
     "tambi�n el valor desconocido.")
);

RealArythmetic_GSL_ = new BOperClassify
(
  I2("Real GSL ",
     "Real GSL "),
  I2("Real Arthymetic Functions from GNU Scientific Library "
     ,
     "Funciones de Aritm�tica Real de la librer�a cient�fica de GNU (GSL)")
);



ComplexArythmetic_ = new BOperClassify
(
  I2("Complex Arthymetic",
     "Aritm�tica Compleja"),
  I2("Complex function arithmetic, logarithms, exponential, trigonometrical, "
     "hyperbolic, etc. When an operation is accomplished would be of the "
     "adequate domain, for example 1/0, is returned the value done not know "
     "( written as the character ? ). also, any operation of real in the one "
     "which appear a value done not know will return also the value done not "
     "know."
     ,
     "Funciones complejas aritm�ticas, logaritmos, exponenciales, "
     "trigonom�tricas, hiperb�licas, etc. Cuando una operaci�n se realiza "
     "fuera del dominio adecuado, por ejemplo 1/0, se devuelve el valor "
     "desconocido ( escrito como el car�cter ? ). As� mismo, cualquier "
     "operaci�n de reales en la que aparezca un valor desconocido devolver� "
     "tambi�n el valor desconocido.")
);
NumericalAnalysis_ = new BOperClassify
(
  I2("Numerical Analysis",
     "C�lculo Num�rico"),
  I2("Functions to calculate numerically integral, derivatives, maximum and "
     "minimal, solutions of non-linear equations, ..."
     ,
     "Funciones para calcular num�ricamente integrales, derivadas, m�ximos "
     "y m�nimos, soluciones de ecuaciones no lineales, ...")
);
Logic_ = new BOperClassify
(
  I2("Logic and order",
     "L�gica y orden"),
  I2("Functions of the algebra of Boole. It is implemented on the real "
     "numbers understanding that the zero is the false value and any other "
     "real value is certain. The value done not know does not has logical "
     "value and should not be used with the logic functions. They are "
     "included here also the comparison functions (just as , less than, ...) "
     "of objects of any type of the permitted for those which be defined an "
     "order. For the numbers is used the natural order, for the texts the "
     "alphabetical order, for the dates the time order, for the sets that "
     "of inclusion, and for the polynomials the order of the degree. In the "
     "rest do not tend make sense the order functions. In any case, the "
     "order functions return a logical value 1 or 0 according to the "
     "accomplished comparison will be certain or false."
     ,
     "Funciones del �lgebra de Boole. Se implementa sobre los n�meros reales "
     "entendiendo que el cero es el valor falso y cualquier otro valor real "
     "es cierto. El valor desconocido no tiene valor l�gico y no debe ser "
     "utilizado con las funciones l�gicas. Se incluyen aqu� tambi�n las "
     "funciones de comparaci�n (igual que , menor que, ...) de objetos de "
     "cualquier tipo de los permitidos para los que est� definido un orden. "
     "Para los n�meros se utiliza el orden natural, para los textos el orden "
     "alfab�tico, para las fechas el orden temporal, para los conjuntos el "
     "de inclusi�n, y para los polinomios el orden del grado. En el resto no "
     "suelen tener sentido las funciones de orden. En cualquier caso, las "
     "funciones de orden devuelven un valor l�gico 1 o 0 seg�n la "
     "comparaci�n realizada sea cierta o falsa.")
);
Statistic_ = new BOperClassify
(
  I2("Statistics",
     "Estad�stica"),
  I2("Functions that return, for a set of numbers, one or several data that "
     "summary somehow the information contained in the original data, those "
     "which can originate of series, sets, etc."
     ,
     "Funciones que devuelven, para un conjunto de n�meros, uno o varios "
     "datos que resumen de alg�n modo la informaci�n contenida en los datos "
     "originales, los cuales pueden provenir de series, conjuntos, etc.")
);
Probability_ = new BOperClassify
(
  I2("Probability Analysis",
     "C�lculo de Probabilidades"),
  I2("Functions of distributions managing of probability more usual. For "
     "each one of they, it is had the distribution function and its inverse, "
     "as well as the density if it is continuous, or the probability if it "
     "is discreet.",
     "Funciones de manejo de distribuciones de probabilidad m�s usuales. "
     "Para cada una de ellas, se dispone de la funci�n de distribuci�n y de "
     "su inversa, as� como de la densidad si es continua, o la probabilidad "
     "si es discreta.")
);
Sthocastic_ = new BOperClassify
(
  I2("Sthocastic's Models",
     "Modelos estoc�sticos"),
  I2("Functions for the analysis of time series, modelling, "
     "forecasting, automatic intervention analysis, diagnostic of "
     "models, etc.",
     "Funciones para el an�lisis de series temporales, modelizaci�n, "
     "previsi�n, an�lisis de intervenci�n autom�tica, diagn�stico de "
     "modelos, etc.")
);
MatrixAlgebra_ = new BOperClassify
(
  I2("Matrix Algebra",
     "�lgebra Matricial"),
  I2("Functions to add, multiply, transpose and to invest matrixs, "
     "to solve linear equation systems, to seek linear relationships, "
     "determinant, factorings of Choleski, Givens and Householder,  "
     "etcetera."
     ,
     "Funciones para sumar, multiplicar, trasponer e invertir matrices, "
     "resolver sistemas de ecuaciones lineales, buscar relaciones lineales, "
     "determinantes, factorizaciones de Choleski, Givens y Householder, "
     "etcetera.")
);
RetardPolynomial_ = new BOperClassify
(
  I2("Retard Polynomial",
     "Polinomios de Retardo"),
  I2("Functions for the managing of delay polynomials, this is, polynomials "
     "in B and F, operating of backward and forward on "
     "time series. They are included the sum, subtraction, product, power, "
     "quotient, finite expansion, etc."
     ,
     "Funciones para el manejo de polinomios de retardo, esto es, polinomios "
     "en B y F, operadores de retardo (Backward) y adelanto (Forward) sobre "
     "series temporales. Se incluyen la suma, resta, producto, potencia, "
     "cociente, expansi�n finita, etc.")
);
TimeAlgebra_ = new BOperClassify
(
  I2("Time Algebra",
     "�lgebra del Tiempo"),
  I2("Functions to represent the social time. In reality, a time set is "
     "a function on the set of the time, from the "
     "principle at the end of the times, that it is capable of "
     "to say if a given date belongs to him or not. \n"
     "The principal reason for which is there has "
     "developed the algebra of the time, that gives name to all the language "
     "(TOL : Time Oriented Language), is "
     "to simplify the calendar effects resulting of the not periodicity "
     "of the social measure of the time, introduced by the heterogeneity of "
     "the months lengths, the leap years and "
     "festive linked to solar calendar as well as to the lunar, as is "
     "the case of the Easter, and other effects of this kind."
     ,
     "Funciones para representar el tiempo social. En realidad, un conjunto "
     "temporal es una funci�n sobre el conjunto del tiempo, desde el "
     "principio al final de los tiempos, que es capaz de decir si una fecha "
     "determinada le pertenece o no.\n"
     "La principal raz�n por la que se ha desarrollado el �lgebra del "
     "tiempo, que da nombre a todo el lenguaje (TOL : Time Oriented Language "
     "o Lenguaje Orientado al Tiempo), es simplificar los efectos calendario "
     "resultantes de la no periodicidad de la medida social del tiempo, como "
     "la introducida por la heterogeneidad de la duraci�n de los meses, la "
     "existencia de a�os bisiestos y de festivos vinculados tanto al "
     "calendario solar como al lunar, como es el caso de la Pascua, y otros "
     "efectos de esta especie.")

);
CalendarVariables_ = new BOperClassify
(
  I2("Calendar Variables",
     "Variables Calendario"),
  I2("Functions that return series as of exclusively time information. These "
     "series are infinite, that is to say, they do not have initial neither "
     "final date."
     ,
     "Funciones que devuelven series a partir de informaci�n exclusivamente "
     "temporal. Estas series son infinitas, es decir, no tienen fecha "
     "inicial ni final.")
);
TimeSeriesAlgebra_ = new BOperClassify
(
  I2("Time Series Algebra",
     "�lgebra de Series Temporales"),
  I2("Functions of series arithmetic, logarithms, exponential, "
     "trigonometrical, hyperbolic, attachment functions, of dating change, "
     "of delay, of equations resolution in finite differences,	etc."
     ,
     "Funciones de series aritm�ticas, logaritmos, exponenciales, "
     "trigonom�tricas, hiperb�licas, funciones de concatenaci�n, de cambio "
     "de fechado, de retardo, de resoluci�n de ecuaciones en diferencias "
     "finitas, etc.")
);
TimeSeriesLogic_ = new BOperClassify
(
  I2("Time Series Logic and Comparisson",
     "L�gica y comparaci�n de Series Temporales"),
  I2("Functions that return series logic, that is to say, formed exclusively "
     "with the certain and false values (1 and 0), and that serve to "
     "accomplish logic operations and of comparison between the values of "
     "different series in corresponding dates"
     ,
     "Funciones que devuelven series l�gicas, es decir, formadas "
     "exclusivamente con los valores cierto y falso (1 y 0), y que sirven "
     "para realizar operaciones l�gicas y de comparaci�n entre los valores "
     "de diferentes series en fechas correspondientes.")
);
BayesDataBase_ = new BOperClassify
(
  I2("Bayes Data Base functions",
     "Funciones de la base de datos Bayes"),
  I2(""
     ,
     "")
);

};


//--------------------------------------------------------------------
BOperator::BOperator(const BText& name, BGrammar* gra,
		     const BText& desc, BOperClassify* cl)

/*! BOperator constructor
 * \param name Name of operator
 * \param gra  Grammar of the result of evaluation
 * \param desc Description of operator
 * \param cl   Classify of operator
 */
//--------------------------------------------------------------------
: BSyntaxObject(name, desc), grammar_(gra), theme_(cl), uCode_(NULL), 
  profiler_(NULL), cppFile_("")
{
  //Std(BText("BOperator constructor body for ") + name);
#ifdef CHK_NULL_GRAMMAR
    if (!gra )
	Error( BText("Null grammar in ") + name + ":" + desc);
#endif
  if(theme_) { 
    if(gra) {
      theme_->Add(this); 
    } else {
      // Skip adding to theme if grammar is NULL - will be added later
      Std(BText("Skipping theme->Add for ") + name + " due to NULL grammar");
    }
  }
  //Std(BText("BOperator constructor completed for ") + name);
}


//--------------------------------------------------------------------
BOperator::~BOperator()

/*! BOperator destructor
 */
//--------------------------------------------------------------------
{
  if(uCode_)
  {
  //uCode_->DecNRefs();
  }
}

//--------------------------------------------------------------------
  BUserFunCode* BOperator::GetCode()
//--------------------------------------------------------------------
{ 
  if(uCode_ && (uCode_->IsAssigned()==0))
  {
    uCode_ = NULL;
  }
  return(uCode_); 
}

//--------------------------------------------------------------------
  void BOperator::PutCode(BUserFunCode* uc) 
//--------------------------------------------------------------------
{ 
  assert(!uCode_);
  uCode_ = uc; 
  if(uCode_)
  {
  //uCode_->IncNRefs();
  }
}

//--------------------------------------------------------------------
void BOperator::AddSystemOperator()
//--------------------------------------------------------------------
{
//Std(BText("\n")+opr->Name()+" "+opr->Description());
//PutSystem(true);
  IncNRefs();
  IncNRefs();
  // Check if symbol table and grammar are initialized before adding
  BGrammar* gra = Grammar();
  if (gra && BGrammar::GetSymbolTablePtr() != NULL) {
    gra->AddObject(this);
  } else {
    // If symbol table or grammar is not ready, add to pending list
    // This can happen with delayed initialization when operators are created
    // before their grammar is fully initialized
    if (!pendingOperators_) {
      pendingOperators_ = new BList();
    }
    pendingOperators_ = Cons(this, pendingOperators_);
    IncNRefs(); // Keep operator alive in pending list
    
    // Always print debug info to track the issue
    if (!gra) {
      Std(BText("AddSystemOperator deferred (NULL grammar) for ") + Name());
    } else {
      Std(BText("AddSystemOperator deferred (no symbol table) for ") + Name());
    }
  }
}

//--------------------------------------------------------------------
void BOperator::RegisterPendingOperators()
//--------------------------------------------------------------------
{
  Std("RegisterPendingOperators called");
  if (!pendingOperators_) {
    Std("  No pending operators to register");
    return;
  }
  
  // Count pending operators first
  int pendingCount = 0;
  BList* p = pendingOperators_;
  while (p) { pendingCount++; p = Cdr(p); }
  Std(BText("  Found ") + pendingCount + " pending operators");
  
  BList* pending = pendingOperators_;
  pendingOperators_ = NIL; // Clear the list to avoid infinite loops
  
  int count = 0;
  int fixedGrammars = 0;
  while (pending) {
    BOperator* opr = (BOperator*)Car(pending);
    if (opr) {
      // First, fix up any missing grammars in external operators
      BExternalOperator* extOpr = dynamic_cast<BExternalOperator*>(opr);
      if (extOpr) {
        fixedGrammars += extOpr->FixupMissingGrammars();
      }
      
      BGrammar* gra = opr->Grammar();
      
      // If the operator has no grammar, try to deduce it from the name
      if (!gra && opr->Name().Find('.') >= 0) {
        // Extract grammar name from operator name (e.g., "AlgLib.Interp.Scalar" -> first part after last dot)
        BText oprName = opr->Name();
        int lastDot = oprName.FindLast('.');
        if (lastDot > 0) {
          BText functionName = oprName.SubString(lastDot + 1, oprName.Length());
          // Try to find the grammar based on the operator's expected return type
          // For AlgLib operators, they typically return Code
          gra = BGrammar::FindByName("Code", false);
          if (gra) {
            opr->grammar_ = gra;
            Std(BText("  Set grammar to Code for operator ") + oprName);
          }
        }
      }
      
      if (gra && BGrammar::GetSymbolTablePtr() != NULL) {
        gra->AddObject(opr);
        count++;
        
        // Also create the BUserFunCode if it was skipped
        BStandardOperator* stdOpr = dynamic_cast<BStandardOperator*>(opr);
        if (stdOpr && !stdOpr->GetCode() && opr->Mode() != BUSERFUNMODE && opr->Name().HasName()) {
          BUserFunCode* uCode = new BUserFunCode("", stdOpr, opr->Description());
          uCode->PutName(opr->Name());
          stdOpr->PutCode(uCode);
        }
      } else {
        // Still can't register, add back to pending list
        if (!pendingOperators_) {
          pendingOperators_ = new BList();
        }
        pendingOperators_ = Cons(opr, pendingOperators_);
      }
      opr->DecNRefs(); // Remove the extra reference from pending list
    }
    pending = Cdr(pending);
  }
  
  if (count > 0) {
    Std(BText("RegisterPendingOperators: Registered ") + count + " operators");
  }
  if (fixedGrammars > 0) {
    Std(BText("RegisterPendingOperators: Fixed ") + fixedGrammars + " missing grammar references");
  }
  if (pendingOperators_) {
    int remaining = 0;
    BList* p = pendingOperators_;
    while (p) { remaining++; p = Cdr(p); }
    Warning(BText("RegisterPendingOperators: Still have ") + remaining + " operators pending");
  }
}

//--------------------------------------------------------------------
const BText& BOperator::CppFile() const 
//--------------------------------------------------------------------
{ 
  return(cppFile_); 
}

//--------------------------------------------------------------------
void BOperator::PutCppFile(const BText& cppFile) 
//--------------------------------------------------------------------
{ 
  cppFile_ = Replace(Replace(cppFile,'\\','/'), TOLCppRoot(), "");
}

//--------------------------------------------------------------------
BEqualOperator::BEqualOperator(BGrammar* gra)

/*! BEqualOperator constructor
 * \param gra Grammar of the result of evaluation
 */
//--------------------------------------------------------------------
    : BOperator
    (
	"=",
	gra,
	I2(BText("Creates a new ")+gra->Name()+" variable",
	   BText("Crea una nueva variable de tipo ")+gra->Name()+"."),
	BOperClassify::General_
    )
{
  AddSystemOperator();
}



//--------------------------------------------------------------------
BUserFunctionCreator::BUserFunctionCreator(BGrammar* gra)

/*! BUserFunctionCreator constructor
 */
//--------------------------------------------------------------------
: BOperator("#F#", gra, BText("Creates a new function."),
  BOperClassify::General_) 
{
  AddSystemOperator();
}



//--------------------------------------------------------------------
BStructCreator::BStructCreator(const BText& name, BGrammar* gra)

/*! BStructCreator constructor
 * \param name Name of operator
 * \param gra  Grammar of the result of evaluation
*/
//--------------------------------------------------------------------
: BOperator(name, gra, "Creates a new structure of set",
  BOperClassify::General_) 
{
  AddSystemOperator();
}


//--------------------------------------------------------------------
BStandardOperator::BStandardOperator(const BText&         name, 
				           BGrammar*      gra,
				           BEvaluator     evaluator,
				           BInt           minArg, 
				           BInt           maxArg,
				     const BText&         args,
				     const BText&         desc,
				           BOperClassify* cl)

/*! BStandardOperator constructor
 */
//--------------------------------------------------------------------
: BOperator(name, gra, desc, cl),
  minArg_(minArg), maxArg_(maxArg), numArg_(maxArg), arguments_(args),
  evaluator_(evaluator)
{
  //Std(BText("BStandardOperator constructor body for ") + name);
  if((Mode()!=BUSERFUNMODE) && (name.HasName()))
  {
    AddSystemOperator();
    if (gra) {
      BUserFunCode* uCode = new BUserFunCode("", this, Description());
      uCode->PutName(name);
      PutCode(uCode);
    } else {
      Std(BText("Skipping BUserFunCode creation for ") + name + " due to NULL grammar");
    }
  }
#ifdef CHK_NULL_GRAMMAR
    if (!gra )
	Error( BText("Null grammar in ") + name + ":" + desc);
#endif
    if (!gra) {
      // Can't validate arguments without grammar - skip for now
      return;
    }
    const BText& graName = gra->Name();
    BBool ok = BTRUE;
    BInt m = Maximum(minArg_,maxArg_);
    BInt	i;
    
    for(i=0; (i<m)&&(i<structs_.Size()); i++) { structs_(i) = NIL; }
    
    if(maxArg_ && (minArg_>maxArg_))
    {
	Error(name+" is defined with "+minArg_+" to "+maxArg_+" argument"
	      +"\n !! FATAL INTERNAL ERROR CONSULT WITH YOUR DISTRIBUTION"
	      +" COMPANY !!");
	abort();
    }
    
    int iniBracket = 0;
    BText aux;

//Trace(Out() << "\nCreating operator ... " << Dump());
    if(args.HasName())
    {
	// classic arguments declaration
	if(args(0)=='(' && args.Last()==')') 
	    aux = args.SubString(1,args.Length()-2);
	// binary argument, args = "a + b <Real a, Real b>"
	else if(((iniBracket=args.Find('{'))!=-1) && (args.Last()=='}')) 
	    aux = args.SubString(iniBracket+1, args.Length()-2);
	else {
	    Error(I2("No legal bracket in arguments of function ",
		     "Error de par�ntesis en los argumentos de la funci�n "
		     "funci�n : ") + "\n" + graName+" "+Name()+" "+args);
	    abort();
	}

	aux.Replace('[',' ');
	aux.Replace(']',' ');
	aux.Replace(", ",",");
	aux.Replace(", ",",");
	aux.Replace(", ",",");
	argTable_.ReallocBuffer(0);
	ReadAllCells(aux, argTable_, ',', ' ');
	
	ok = (maxArg&&(argTable_.Size()==maxArg)) ||
	    (!maxArg&&((argTable_.Size()==m+2)&&(argTable_[m+1][0]=="...")));
	argTable_.ReallocBuffer(maxArg?maxArg:minArg+1);
	if(!ok)
	{
	    Error(I2("Bad arguments number in specification of function ",
		     "N�mero err�neo de argumentos en la especificaci�n de la "
		     "funci�n : ") + "\n" + graName+" "+Name()+" "+args);
//    argTable_.ReallocBuffer(0);
	    abort();
	}
    } 
}



//--------------------------------------------------------------------
BInternalOperator::BInternalOperator(const BText&         name, 
				           BGrammar*      gra,
				           BEvaluator     evaluator,
				           BInt           minArg, 
				           BInt           maxArg,
				     const BText&         args,
				     const BText&         desc,
				           BOperClassify* cl)
    
/*! BInternalOperator constructor
 * \param name
 * \param gra
 * \param evaluator
 * \param minArg
 * \param maxArg
 * \param args
 * \param desc
 * \param cl
 */
//--------------------------------------------------------------------
: BStandardOperator(name, gra, evaluator, minArg, maxArg, args, desc, cl)
{
  if(argTable_.Size())
    {
#ifdef CHK_NULL_GRAMMAR
	if (!gra )
	    Error( BText("Null grammar in ") + name + ":" + desc);
#endif
	const BText& graName = gra->Name();
	BInt m = Maximum(minArg_,maxArg_);
	BBool ok = BTRUE;
	for(BInt i=0; i<m; i++)
	{
	    if(argTable_[i][0]!=graName)
	    {
		Error(argTable_[i][0] + " " + argTable_[i][1] + "\n" +
		      
		      I2("It was expected the data type ",
			 "Se esperaba el tipo de datos ") + graName +
		      I2(" in specification of function ",
			 " en la especificaci�n de la funci�n ") + "\n" +
		      gra->Name() + " " + Name() + args);
		ok = BFALSE;
	    }
	}
	if(!ok) { abort(); }
    }
}


//--------------------------------------------------------------------
BExternalOperator::BExternalOperator(const BText&         name,
				           BGrammar*      gra,
				           BList*         grammars,
				           BEvaluator     evaluator,
				           BInt           min,
				           BInt           max,
				     const BText&         args,
				     const BText&         desc,
				           BOperClassify* cl)
    
/*! BExternalOperator constructor
 * \param name
 * \param gra
 * \param grammars BList of Grammars
 * \param evaluator
 * \param min
 * \param max
 * \param args
 * \param desc
 * \param cl
 */
//--------------------------------------------------------------------
: BStandardOperator(name, gra, evaluator, min, max, args, desc, cl)
{
  BArray<BAtom*> buf;
  LstToArr(grammars, buf);
  grammars_.AllocBuffer(buf.Size());
  for(BInt i=0; i<buf.Size(); i++)
  {
    grammars_[i].AllocBuffer(1);
  	grammars_[i][0] = (BGrammar*)buf[i];
  }
  grammars = LstDestroyAllCons(grammars);
}


//--------------------------------------------------------------------
BExternalOperator::BExternalOperator(const BText&         name,
				           BGrammar*      gra,
				     const BText&         grammars,
				           BEvaluator     evaluator,
				           BInt           min,
				           BInt           max,
				     const BText&         args,
				     const BText&         desc,
				           BOperClassify* cl)
    
/*! BExternalOperator constructor
 * \param name
 * \param gra
 * \param grammars BText
 * \param evaluator
 * \param min
 * \param max
 * \param args
 * \param desc
 * \param cl
 */
//--------------------------------------------------------------------
: BStandardOperator(name, gra, evaluator, min, max, args, desc, cl)
{
  //Std(BText("BExternalOperator(BText) constructor body for ") + name);
  BArray<BText> names;
  int numArg = 0, n, k;
  ReadAllTokens(grammars, names, ' ');
  grammars_.ReallocBuffer(names.Size());
  structs_ .ReallocBuffer(names.Size());
//Std(BText("\nParsing grammars (") +grammars+")");
//Std(BText("\nAvalaible grammars ")+LstText(BGrammar::Instances()));
   BBool ok = BTRUE;
  for(n=0; n<names.Size(); n++)
  {
    BText opt = names[n];
    opt.Compact();
    if(argTable_.Size())
    {
      if(argTable_[n][0]!=opt)
      {
	Error(I2("It was expected the data type ",
		 "Se esperaba el tipo de datos ") + opt +
	      I2(" in specification of function ",
		 " en la especificaci�n de la funci�n ") + "\n" +
	      (gra ? gra->Name() : "NULL") + " " + Name() + args + "\n" +
	      I2("but it was found ", "pero se encontr� ")+
	      argTable_[n][0] + " " + argTable_[n][1] + "\n");
	ok = BFALSE;
      }
    }
    if(!ok) { abort(); }
//  Std(BText("\nGrammar ")+n+" = (" +opt+")");
    if(opt(0)=='{')
    {
      BArray<BText> options;
      opt.PutChar(0,' ');
      opt.PutChar(opt.Length()-1,' ');
      opt.Compact();
      ReadAllTokens(opt,options,'|');
      grammars_[n].AllocBuffer(options.Size());
      for(k=0; k<grammars_[n].Size(); k++)
      {
        grammars_[n][k] = BGrammar::FindByName(options[k],false);
        if(!grammars_[n][0])
        {
          Error(opt+I2(" at options ", " de las opciones ")+opt+
                I2(" is not a data type. Cannot create function ",
	              " no es un tipo de datos. No se puede crear la funci�n ") +
	              (gra ? gra->Name() : "NULL") + " " + Name() + "(" + grammars + ")");
          exit(-1);
        }
      }
    }
    else
    {
      grammars_[n].AllocBuffer(1);
      //Std(BText("Looking up grammar: ") + opt);
      grammars_[n][0] = BGrammar::FindByName(opt,false);
      //if (!grammars_[n][0]) {
      //  Std(BText("  Grammar not found: ") + opt);
      //}
    }
    structs_ [n] = NIL;
    if(!grammars_[n][0])
    {
      if((structs_ [n] = FindStruct(opt)))
      {
	      grammars_[n][0] = GraSet();
      }
    }
    if(!grammars_[n][0])
    {
      // Grammar not found - this can happen during static initialization
      // when operators are created before grammars are initialized
      if (!gra) {
        // Skip validation during static initialization
        //Std(BText("Skipping grammar validation for ") + Name() + " during static init (missing " + opt + ")");
        grammars_[n][0] = NIL; // Will be fixed later by RegisterPendingOperators
        
        // Save the grammar name in argTable for later fixup
        if (argTable_.Size() <= n) {
          argTable_.ReallocBuffer(n + 1);
        }
        if (argTable_[n].Size() == 0) {
          argTable_[n].AllocBuffer(2);
          argTable_[n][0] = opt; // Grammar name
          argTable_[n][1] = BText("arg") + (n+1); // Default arg name
        }
        
        numArg++; // Count it anyway to avoid argument count errors
        continue;
      }
      Error(opt+I2(" is not a data type. Cannot create function ",
	    " no es un tipo de datos. No se puede crear la funci�n ") +
	    (gra ? gra->Name() : "NULL") + " " + Name() + "(" + grammars + ")");
      exit(-1);
    }
    else
    {
      numArg++;
    }
  }
  
  //Std(BText("BExternalOperator finished parsing grammars for ") + name);

  BBool argumentsNumberError = ( max && (numArg!=max  )) ||
			       (!max && (numArg!=min+1));
  if(argumentsNumberError)
  {
    Error(I2("Wrong number of arguments in definition of ",
	     "Numero de argumentos err�neos en la definici�n de ")+
	  (Grammar() ? Grammar()->Name() : "NULL") + " " + Name() + "(" + grammars + ").");
    exit(-1);
  }
  
  //Std(BText("BExternalOperator constructor completed for ") + name);
}

//--------------------------------------------------------------------
int BExternalOperator::FixupMissingGrammars()
//--------------------------------------------------------------------
{
  int fixed = 0;
  
  // Go through all grammar arrays and fix NULL entries
  for(BInt n = 0; n < grammars_.Size(); n++) {
    for(BInt k = 0; k < grammars_[n].Size(); k++) {
      if(!grammars_[n][k]) {
        // Try to find the grammar name from argTable
        if(n < argTable_.Size() && argTable_[n].Size() > 0) {
          BText grammarName = argTable_[n][0];
          BGrammar* gra = BGrammar::FindByName(grammarName, false);
          if(gra) {
            grammars_[n][k] = gra;
            fixed++;
            Std(BText("Fixed missing grammar ") + grammarName + " for " + Name());
          }
        }
      }
    }
  }
  
  return fixed;
}


//--------------------------------------------------------------------
BUserFunction::BUserFunction(const BText& name, BGrammar* gra)

/*! BExternalOperator constructor
*/
//--------------------------------------------------------------------
: BExternalOperator("", gra, NIL),
  declaration_(NIL),
  definition_ (NIL),
  declare_(""),
  define_(""),
  staticOwner_(NULL)
{
  PutName(name);
  PutTheme(BOperClassify::Various_);
  PutCode(new BUserFunCode(name, this, Description()));
}


//--------------------------------------------------------------------
BUserFunction::BUserFunction(const BText& name, BGrammar* gra,
			     const BText& dec, const BText& def)
    
/*! BExternalOperator constructor
 * \param name
 * \param gra
 * \param dec
 * \param def
 */
//--------------------------------------------------------------------
: BExternalOperator("", gra, NIL),
  declaration_(NIL),
  definition_ (NIL),
  declare_(""),
  define_(""),
  staticOwner_(NULL)
{
  PutName(name);
  PutDescription(name);
  SetExpression(dec, def);
}



//- static member ----------------------------------------------------
/* Returns the active BUserFunction, that is in execution at the 
 * current time.
 * \sa AddtActiveFunction, RemoveActiveFunction
 */
BUserFunction* BUserFunction::ActiveFunction() 
{
  if(activeFunctions_.size()>0)
	  return activeFunctions_.back();
  else return NIL;
}

//- static member ----------------------------------------------------
/* Insert a BUserFunction in the \a activeFunctions_ (STL) vector.
 * BUserFunction inserted must be the function in execution at the
 * current time.
 * \sa ActiveFunction, RemoveActiveFunction
 */
void BUserFunction::AddActiveFunction(BUserFunction* uFunction) 
{
  activeFunctions_.push_back(uFunction);
}


//- static member ----------------------------------------------------
/* Shows 
 */
//--------------------------------------------------------------------
BText BUserFunction::GetCallStack()
{
  BText txt;
  if(activeFunctions_.size())
  {
    int i;
    txt << "\n[Call stack]\n";
    for(i=activeFunctions_.size()-1; i>=0; i--)
    {
      BUserFunction* usf = activeFunctions_[i];
      txt << BText("  [")+(i+1)+"] "+
        usf->Grammar()->Name()+" "+
        usf->FullName()+" "+
        usf->Arguments()+"\n";
    }
  }
  return(txt);
}

void BUserFunction::ShowCallStack()
{
  if(activeFunctions_.size())
  {
    int i;
    Std("\n[Call stack]\n");
    for(i=activeFunctions_.size()-1; i>=0; i--)
    {
      BUserFunction* usf = activeFunctions_[i];
      Std(BText("  [")+(i+1)+"] "+
        usf->Grammar()->Name()+" "+
        usf->FullName()+" "+
        usf->Arguments()+"\n");
    }
  }
}


//- static member ----------------------------------------------------
/* Erase the active BUserFunction from the \a activeFunctions_ (STL) vector, 
 * that was in execution.
 * \sa ActiveFunction, AddtActiveFunction
 */
void BUserFunction::RemoveActiveFunction() 
{
    if(activeFunctions_.size()>0) activeFunctions_.pop_back();
}

//--------------------------------------------------------------------
/* Set attribute BText \a inFile_, that stores the name of the file
 * where this BUserFunction has been declared and defined.
 */
void BUserFunction::SetInFile(const BText& inFile) 
{
    inFile_ = inFile;
}

