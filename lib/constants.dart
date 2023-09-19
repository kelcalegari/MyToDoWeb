//Texts


import 'package:flutter/material.dart';

const programName = "MyToDo";

const homePageTitle = "Home";
const settingPageTitle = "Configurações";

const emailLabel = 'E-mail';
const passwordLabel = 'Senha';
const rePasswordLabel = 'Repita a senha';
const nameLabel = 'Nome Completo';

const registerButtonLabel = " Registre-se";
const haveAccountButtonLabel = "Possui conta?";
const noAccountButtonLabel = "Não possui conta?";
const loginButtonLabel = "Login";

const emailRequiredMessage = "Informe o e-mail";
const invalidEmailMessage = 'Informe um E-mail Válido!';
const emailExistsMessage = "Email já existente!";

const accountNotFoundMessage = "Usuário não encontrado ou não autorizado para atualização.";
const passwordMismatchMessage = "Senha não confere";
const passwordRequiredMessage = 'Informe a senha';
const incorrectPasswordMessage = 'Senha Incorreta';
const weakPasswordMessage =
    "Senha Fraca! \n Utilize senha com mais de 6 letras, com maiúsculas, minúsculas e números.";

const userNotFoundMessage = "Usuário não localizado";
const noConnectionMessage = "Verifique sua conexão de internet";
const tooManyAttemptsMessage = "Muitas tentativas, espere 3 min";

const nameRequiredMessage = "Nome não Informado";
const invalidNameMessage = "Nome Inválido";

const singleTagMessage = "Informe pelo menos uma Tag!";

const labelOption = 'Selecione uma opção';
const priorityText = "Prioriedade";
const tagText = "Tag";
const deadlineText = "Prazo";
const taskText = "Tarefa";
const newTaskText = "Nova Tarefa";
const titleText = "Titulo";
const enterTitleText = "Informe o titulo";
const detailsText = "Detalhes";
const saveText = "Salvar";
const deleteText = "Excluir";
const cancelText = "Cancelar";
const editText = "Editar";
const listText = 'Listas';
const accountText  = 'Conta';
const basicTaskText = 'Tarefas basicas';
const advancedTask = 'Tarefas Avancadas';
const typeText = "Tipo";
const newTagText = "Nova Tag";
const logoutText = "Logout";
const currentPasswordText = "Senha Atual";
const configText = "Configurações";
const okText = 'OK';

const List<String> priorityOpts = ['Baixa', 'Media', 'Alta', 'Urgente'];

//ListasPadroes

const List<IconData> iconsList = [
  Icons.work,
  Icons.school,
  Icons.fitness_center,
  Icons.shopping_cart,
  Icons.local_movies,
  Icons.home_outlined,
  Icons.group,
  Icons.flight,
  Icons.beach_access
];

// Int
const mobileWidth = 600.00;
const desktopMinWidth = 1100;
const tabletMinWidth = 600;
//const mobileMinWidth = 0;

//Colors

const primaryColor = 0xFF0F6BAC;
const secondaryColor = 0xFFed7111;
const tertiaryColor = 0xFFf89f11;

const primaryDarkColor = 0xFFac5010;
const secondaryDarkColor = 0xFFed7111;
const tertiaryDarkColor = 0xFFf89f11;

ThemeData lightTheme = ThemeData(
  primaryColor: const Color(primaryColor),
  shadowColor: Colors.grey.withOpacity(0.5),
  colorScheme: const ColorScheme(
    background: Colors.white,
    brightness: Brightness.light,
    primary: Color(primaryColor),
    onPrimary: Colors.white,
    secondary: Color(secondaryColor),
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(primaryColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor:
          const Color(secondaryColor), // Set your preferred button color here.
      foregroundColor: Colors.white, // Set the text color.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(tertiaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9.0),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEDF1F8)),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gapPadding: 4.0),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(primaryColor),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gapPadding: 4.0),
    filled: true,
    fillColor: Color(0xFFEDF1F8),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gapPadding: 4.0),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gapPadding: 4.0),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(secondaryColor),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color?>(const Color(tertiaryColor)),
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(fillColor: Colors.cyan)),
);

ThemeData darkTheme = ThemeData(
    primaryColor: const Color(primaryColor),
    shadowColor: Colors.white.withOpacity(0.5),
    colorScheme: const ColorScheme(
      background: Color(0xFF333333),
      brightness: Brightness.dark,
      primary: Color(primaryColor),
      onPrimary: Colors.white,
      secondary: Color(secondaryColor),
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.redAccent,
      onBackground: Colors.white,
      surface: Color(primaryColor),
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(primaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(
            secondaryColor), // Set your preferred button color here.
        foregroundColor: Colors.black, // Set the text color.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(tertiaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEDF1F8)),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 4.0),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(primaryDarkColor),
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 4.0),
      filled: true,
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 4.0),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 4.0),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(secondaryColor),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color?>(const Color(tertiaryColor)),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Colors.black,
      dialBackgroundColor: Colors.white,
      entryModeIconColor: Colors.white,
      dialTextColor: Color(primaryDarkColor),
    ));
