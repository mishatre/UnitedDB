
Procedure BeforeWrite(Cancel)
	
	//If Not Cancel Then 
	//	
	//	If Not ValueIsFilled(RoleOfUser) Then 
	//		
	//		Role = "Admin";
	//		
	//	EndIf;
	//	
	//	If Not Role = "Admin" Then 
	//		
	//		Role = "SR";
	//		
	//		If RoleOfUser.Role = "Unknown" Then 
	//			
	//			Role = "Unknown";
	//			
	//		ElsIf RoleOfUser.Role = "SRM" Then
	//			
	//			Role = "SRM";
	//			
	//		EndIf;
			
			// Создать пользователя и установить UserID
			ParametersStructure = New Structure();
			ParametersStructure.Insert("FullName", Наименование);
			ParametersStructure.Insert("UserName", Логин);
			ParametersStructure.Insert("UserID", UserID);
			//ParametersStructure.Insert("Role", Role);
			ParametersStructure.Insert("Password", Пароль);
			//ParametersStructure.Insert("InterfaceLanguage", InterfaceLanguage);
			
			UserID = Пользователи.CreateUser(ParametersStructure);
	//		
	//	EndIf;
	//	
	//EndIf;
	
EndProcedure









