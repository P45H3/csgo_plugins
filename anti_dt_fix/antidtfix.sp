#include <sourcemod>
#include <sdktools>
#include <scp>
#include <csgo_colors>

#define PLUGIN_NAME        "EeXOMI Anti DT Fix"
#define PLUGIN_VERSION    "0.0.1"

static char sServerName[256];
 
public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author        = "P45H3",
    version        = PLUGIN_VERSION,
    url            = "By rules?"
}
 
bool bFreezeTime = 1;
int nType = 2;
int nLastSWClient = -1;

public void OnPluginStart(){
	new Handle:ee_exploitfixtype = CreateConVar("ee_exploitfixtype", "2", "\n1 - Kicks out from the server.\n2 - Moves to spectators." ); 
	
	AddCommandListener(OnSWTeam, "jointeam");
	
	HookConVarChange(ee_exploitfixtype, OnFixTypeChanged); 
   	nType = GetConVarInt(ee_exploitfixtype);
}

public OnFixTypeChanged(Handle:convar, const String:oldValue[], const String:newValue[]) 
{ 
	nType = GetConVarInt(convar);
}
 
public void CheckCvar(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue, any value){
	if(GetClientTeam(client) == 0)
		return;
	char clientname[MAX_NAME_LENGTH];
    	GetClientName(client, clientname, MAX_NAME_LENGTH);
	
	int val = StringToInt(cvarValue);
	
	if(val == 0){
		if(nType == 1){
			KickClient(client, "Set the cl_lagcompensation to 1");
		}
		
		else if(nType == 2){
			ChangeClientTeam(client, 1);
			CGOPrintToChat(client, "{LIGHTBLUE}[EeXOMI]{GREEN} %s {LIGHTBLUE}set the {LIGHTRED}cl_lagcompensation{LIGHTBLUE} to 1", clientname);
		}
		
		else {
			//Dolbaeb?
		}	
	}
}


void ProcessLagComp(int client){
	QueryClientConVar(client, "cl_lagcompensation", CheckCvar);
}
 
public void OnClientPutInServer(int client){
	//ProcessLagComp(client);
}
 
public Action OnSWTeam(int client, const char[] command, int args){
	ProcessLagComp(client);
	
	return Plugin_Continue; 
}

 
public void OnClientSettingsChanged(int client){
//	ProcessLagComp(client);
}
 
