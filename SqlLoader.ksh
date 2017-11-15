!/bin/ksh
#*****************************************************************************
#Shell script to run SQL LOADER

#*****************************************************************************

# Declaring variables
prog_name=ezorgnwldr

# Declare USAGE variable
USAGE="Usage: ${prog_name}.ksh <environment> <Control File> <Data File>"

# Validate parameters
if [[ $# -lt 3 ]]
then
   echo "Environment,Control File,Data File are not passed in.  Aborting."
   echo $USAGE
   exit 255   # FATAL
fi

export ENVIRON=$1
p_control_file=$2
p_data_file_name=$3


# Load environment setting config
. /export/home/`whoami`/.profile

echo Script ${prog_name} started at `date`

# initialize log and out directories

   l_output_dir="/u01/app/ez/$ENVIRON/log"
   l_log_dir="/u01/app/ez/$ENVIRON/log"
   l_file=`basename $3`   
   
   # Loading data using SQL Loader Utility 
   echo "\nExecuting Loader command "
   echo "-------------------------"
   echo ${p_control_file}
   echo ${p_data_file_name}
   echo ${l_output_dir}/${l_file}.bad
   echo ${l_log_dir}/${l_file}.log
   echo ${l_output_dir}/${l_file}.dsc


#silent=header silent=feedback silent=partitions
   sqlldr /@${ORACLE_SERVICE} control=${p_control_file} \
   data=${p_data_file_name} \
   bad=${l_output_dir}/${l_file}.bad \
   log=${l_log_dir}/${l_file}.log \
   discard=${l_output_dir}/${l_file}.dsc \
   errors=10000

prog_code=$?

if [ ${prog_code} -ne 0 ]
then
    echo "Error while executing the script."
    exit 255
fi

echo "Data load completed successfully."
echo "Script ${prog_name}.ksh executed successfully"
echo Script ${prog_name} ended at `date`
exit 0
