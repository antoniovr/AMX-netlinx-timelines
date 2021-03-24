PROGRAM_NAME='Timelines'
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/11/2019  AT: 09:39:04        *)
(***********************************************************)

DEFINE_DEVICE 

    dvTp = 10001:1:0
    vdvSystem = 33000:1:0

#include 'EarAPI.axi'

DEFINE_CONSTANT

    // Id del timeline, única por cada bloque de código cerrado
    volatile long _TLID = 1

DEFINE_VARIABLE

    // Definimos los tiempos de los que está compuesto nuestro timeline
    volatile long lTimes[] = {2000,2000,2000,2000,2000}

    volatile integer anCanales[] = {1,2,3,4,5,6}

DEFINE_START

    /*
	Argumentos
	1 - ID del timeline, debe ser un long
	2 - Tiempos de los que está compuesto el timeline
	3 - Elegir entre:
		* timeline_relative: cada tiempo definido es a partir del tiempo anterior
		* timeline_absolute: cada tiempo definido es a partir del inicio del timeline
	4 - Elegir entre:
		* timeline_once: el TL se ejecuta una única vez
		* timeline_repeat: el timeline 
    */
    
DEFINE_EVENT

    timeline_event[_TLID]
    {
	// Entrará aquí por cada iteracción del timeline
	send_string 0,"'timeline.sequence: ',itoa(timeline.sequence)" // timeline.sequence Nos indica en qué paso del timeline nos encontramos
    }
	
    channel_event[vdvSystem,anCanales]
    {
	on:
	{
	    stack_var integer nCanalActivado
	    nCanalActivado = get_last(anCanales)
	    switch(nCanalActivado)
	    {
		case 1: 
		{
		    send_string 0,'Creamos el timeline'
		    timeline_create(_TLID,lTimes,length_array(lTimes),timeline_relative,timeline_repeat)
		}
		case 2:
		{
		    send_string 0,'Pausamos el timeline'
		    timeline_pause(_TLID)
		}
		case 3:
		{
		    send_string 0,'Continuamos la ejecución del timeline'
		    timeline_restart(_TLID)
		}
		case 4:
		{
		    lTimes[1] = 1000
		    lTimes[2] = 2000
		    lTimes[3] = 3000
		    lTimes[4] = 4000
		    lTimes[5] = 5000
		    send_string 0,'Cambiamos los tiempos del array'
		    timeline_reload(_TLID,lTimes,length_array(lTimes))
		}
		case 5:
		{
		    send_string 0,'Matamos el timeline'
		    timeline_kill(_TLID)
		}
		case 6:
		{
		    send_string 0,"'Comprobamos si el timeline _TLID está activo: ',itoa(timeline_active(_TLID))"
		}
	    }
	}
    }

(***********************************************************)
(*		    	END OF PROGRAM			   *)
(***********************************************************) 