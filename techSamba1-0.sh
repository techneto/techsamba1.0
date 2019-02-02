#!/bin/bash
#Joaquim Neto 85 9 8694.3923 - technetotutoriais@gmail.com

COR_INICIO="\033[01;33m"
COR_FIM="\033[01;37m"


pular(){
	echo ""
}
junpLine(){
	clear
	echo -e $COR_INICIO"----------------------------------------------------------------------------------"
	figlet "TechSamba V1.0"
	echo "----------------------------------------------------------------------------------"
	echo "Equipe: Joaquim Neto, Adriellison Ferreira"
	echo -e "----------------------------------------------------------------------------------"$COR_FIM" \n"
}

menuUsersFile(){
	while true; do
		echo "1) Escolher arquivo"
		echo "2) Ver exemplo de arquivo"
		echo "0) Voltar"
		echo -e $COR_INICIO"Digite o que deseja: "$COR_FIM; read OPCAO
		case $OPCAO in
			1)addUsersFile;;
			2)modelFile;;
			0)exit;;
			*)echo "Opção invalida!"
	esac
	done
}
########################################### PARAMOS AQUI #########################################################
addUsersFile(){
	junpLine
	ls | sort | cat -n
	echo -e $COR_INICIO"Digite o número do arquivo: "$COR_FIM; read NUM_FILE
	ls | sort > /tmp/arquivo.txt
	export FILE=$(head /tmp/arquivo.txt -n`echo $NUM_FILE` | tail -n1)
	junpLine
	echo -e $COR_INICIO"Está certo que o arquivo é: $FILE \n1-Sim 2-Não 3-menu"$COR_FIM ; read CONFIRMAR
		junpLine
	if [ $CONFIRMAR == 1 ]; then
		#echo -e $COR_INICIO"Digite o número do arquivo: "$COR_FIM; read NUM_FILE
		junpLine
		echo -e $COR_INICIO"Seu arquivo segue esse padrão? \n\n\tEX: Matricula;Nome;Email;CPF;Telefone \n\n1-Sim 2-Não 3-menu"$COR_FIM ; read CONFIRMAR
		if [ $CONFIRMAR == 1 ]; then
			listGroup
			echo -e $COR_INICIO"Está certo que quer adiconar todos os usuários no grupo: $GROUP \n\n1-Sim 2-Não"$COR_FIM; read CONFIRMA;
			while [ $CONFIRMA != 1 ]; do
				listGroup
			done
			while read LINHA; do
				samba-tool user add `echo -n $LINHA | cut -d ';' -f 1` '12345@A' --must-change-at-next-login --given-name="`echo -n $LINHA | cut -d';' -f2`" --mail-address="`echo -n $LINHA | cut -d ';' -f 3`" --telephone-number="`echo -n $LINHA | cut -d ';' -f 5`" --description="`echo -n 'CPF: '; echo -n $LINHA | cut -d ';' -f 4`"
				samba-tool group addmembers `echo $GROUP` `echo -n $LINHA | cut -d ';' -f1`; pular
			done < $FILE
		elif [ $CONFIRMAR == 2 ]; then
			junpLine
			addUsersFile
		else
			junpLine
			echo -e $COR_INICIO"Altere o padrão do seu arquivo ou não será possível continuar!\nPressione enter para continuar!"$COR_FIM ; read CONFIRMAR
			menu
		fi
	elif [ $CONFIRMAR == 2 ]; then
		junpLine
		addUsersFile
	else
		junpLine
		menu
	fi


}

listUsers(){
	junpLine
	#lista usuarios e seleciona
	samba-tool user list | cat -n | less
	samba-tool user list > /tmp/usersTemp.txt
	echo -e $COR_INICIO"Digite o numéro do usuario: "$COR_FIM; read NUM_USER;
	export USER=$(head /tmp/usersTemp.txt -n`echo $NUM_USER` | tail -n1)
	rm /tmp/usersTemp.txt
}

listGroup(){
	#lista grupo e adiciona usuario ao grupo
	samba-tool group list | cat -n | less
	samba-tool group list > /tmp/groupTemp.txt
	junpLine
	echo -e $COR_INICIO"Digite o número do grupo: "$COR_FIM; read NUM_GROUP;
	export GROUP=$(head /tmp/groupTemp.txt -n`echo $NUM_GROUP` | tail -n1)
	rm /tmp/groupTemp.txt

}

listGroupMembers(){
	listGroup
	junpLine
	samba-tool group listmembers `echo $GROUP` | cat -n
	pular
}

addUserGroup(){
	listUsers
	listGroup
	junpLine
	samba-tool group addmembers `echo $GROUP $USER`
	pular
}

removeUserGroup(){
	listGroupMembers
	pular
	echo -e $COR_INICIO"Digite o número do usuário: "$COR_FIM
	read NUM_MEMBER_GROUP
	samba-tool group listmembers `echo $GROUP` > /tmp/membersGroup.txt
	export USER=$(head /tmp/membersGroup.txt -n `echo $NUM_MEMBER_GROUP` | tail -n1)
	rm /tmp/membersGroup.txt
	junpLine
	samba-tool group removemembers `echo $GROUP $USER`
	pular
}
#----------------------------------------------------------------
saudacao(){
	junpLine
}

#--opcoes do menu--
list(){
	echo "Listar usuários:"
	samba-tool user list | less
	junpLine
}
list_group(){
	echo "Listar grupos:"
	samba-tool group list | less
	junpLine
}
add(){
	pular
	echo -e $COR_INICIO"Nome do novo usuário: "$COR_FIM;read NOME
	junpLine
	samba-tool user add $NOME
	pular
}
add_group(){
	pular
	echo -e $COR_INICIO"Nome do novo grupo: "$COR_FIM
	read NOME_GRUPO
	junpLine
	samba-tool group add $NOME_GRUPO
	pular
}
del(){
	listUsers
	echo "Qual o número do usuário que deseja deletar: "
	junpLine
	samba-tool user delete $USER
	pular
}
del_group(){
	listGroup
	junpLine
	samba-tool group delete $GROUP
	pular
}
menu(){
while true; do
	echo "a) Adicionar usuários a partir de arquivo"
	echo "1) Listar usuários"
	echo "2) Listar grupos"
	echo "3) Listar membros de um grupo"
	echo "4) Criar usuário"
	echo "5) Criar grupo"
	echo "6) Deletar usuário"
	echo "7) Deletar grupo"
	echo "8) Adicionar usuário a um grupo"
	echo "9) Remover usuário de um grupo"
	echo "0) Sair"
	pular
	echo -e $COR_INICIO"Digite o que deseja: "$COR_FIM; read opcao
	case $opcao in
		a)addUsersFile;;
		1)list;;
		2)list_group;;
		3)listGroupMembers;;
		4)add;;
		5)add_group;;
		6)del;;
		7)del_group;;
		8)addUserGroup;;
		9)removeUserGroup;;
		0)exit;;
		*)junpLine;echo "Opção invalida!";pular
	esac
done
}

saudacao
menu
