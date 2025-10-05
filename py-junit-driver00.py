import os
import shutil
import glob
import io
import re

##
# @todo
# 1. create a command line option handler for java_file_to_test
#   b_use_extdirs_option
#.  web_inf_lib_dir
class RunnerJunitConfig00:
  def __init__(self):
    self.script_dir =self.compute_script_dir()
    self.curr_dir =self.compute_curr_dir()

    self.slash =os.sep;
    self.pathsep =':' if os.sep == '/' else ';'

    self.java_file_to_test ='a/b/dumbtester00/service/UtilityATest.java'
    self.class_file_to_test =self.compute_class_file_to_test( self.java_file_to_test)

    self.web_inf_lib_dir =self.compute_web_inf_lib_dir( 'target/dumbtester00-0.0.1-SNAPSHOT/WEB-INF/lib')

    self.temp_dir =os.path.join( self.curr_dir, 'temp')

    self.javac_exe =shutil.which('javac.exe')
    self.java_exe =shutil.which('java.exe')
    self.jar_exe =shutil.which('jar.exe')

    self.src_test_java_dir =os.path.join(self.curr_dir, 'src', 'test', 'java')

    self.classes_dir =os.path.join(self.curr_dir, 'target', 'classes')
    self.classes_dir =re.sub('^[A-Z]:', '', self.classes_dir, 1).replace('\\','/')

    self.test_classes_dir =os.path.join(self.curr_dir, 'target', 'test-classes')
    self.test_classes_dir =re.sub('^[A-Z]:', '', self.test_classes_dir, 1).replace('\\','/')

    self.junit_standalone_jar_orig =os.path.join( self.script_dir, 'junit-platform-console-standalone-1.13.0-M3.jar')
    self.junit_tainted_jar =os.path.join( self.temp_dir, 'junit-tainted.jar')

    self.b_use_extdirs_option =True

  def compute_script_dir(self):
    return os.path.dirname(os.path.abspath(__file__))
  
  def compute_curr_dir(self):
    return os.path.abspath( os.getcwd() )
  
  def compute_class_file_to_test( self, java_file_to_test):
    class_file_to_test =java_file_to_test
    class_file_to_test =class_file_to_test[0:-5]
    class_file_to_test =re.sub('[\\\\/]', '.', class_file_to_test)
    return class_file_to_test
  
  def compute_web_inf_lib_dir(self, web_inf_lib_dir ):
    dir =os.path.join(self.curr_dir, web_inf_lib_dir)
    dir =os.path.abspath( dir )
    dir =dir.replace('\\', '/')
    dir =re.sub( '^[A-Z]:', '', dir)
    return dir
  
  def __str__(self)
    return f"RunnerJunitConfig00( {self.__dict__})"
  
class RunningJunit:
  def __init__(self):
    self.c =None
  
  def configure(self, config):
    self.c =config

  def run(self):
    if not self.is_valid_precondition():
      return
    
    print("Running")
    self.compile_junit_test_file()

    self.create_junit_tainted_jar()

    self.run_test_class()

  def is_valid_precondition(self):
    b_is_valid =os.path.exists( self.c.src_test_java_dir)
    if b_is_valid:
      print(f"Confirmed existence of directory: : {self.c.src_test_java_dir}")
    else:
      print(f"Error: directory, {self.c.src_test_java_dir}, not detected.")
      
    return b_is_valid
  
  def run_command(self, command):
    print(f"Running command: {command}")
    rval =os.system( command )
    return rval
  
  def compile_junit_test_file(self):
    class_path =self.compose_classpath( self.c.src_test_java_dir, self.c.classes_dir, self.c.test_classes_dir, self.c.junit_standalone_jar_orig)

    if not os.path.exists( self.c.test_classes_dir ):
      os.makedirs( self.c.test_classes_dir )

    if self.c.b_user_extdirs_option:
      # then do use -extdirs option -- works with java 1.8
      ary_command =[self.c.java_exe, '-d', self.c.test_classes_dir, '-cp', class_path, '-extdirs', self.c.web_inf_lib_dir, self.c.java_file_to_test ]
    else:
      ary_command =[self.c.java_exe, '-d', self.c.test_classes_dir, '-cp', class_path,  self.c.java_file_to_test ]

    s_command =' '.join(ary_command)

    prev_dir =os.getcwd()
    os.chdir( self.c.src_test_java_dir)

    rval =self.run_command( s_command )
    os.chdir( prev_dir )
    return rval

  def compose_classpath( self, *paths):
    class_path =self.c.pathsep.join( paths)
    return class_path
  
  def create_junit_tainted_jar_file(self):
    if not os.path.exists( self.c.temp_dir):
      os.mkdirs( self.c.temp_dir)
    
    os.chdir( self.c_temp_dir )

    # copy
    shutil.copy( self.c.junit_stanalone_jar_orig, self.c.junit_tainted_jar)

    # create a custome manifest that includes WEB-INF/lib/*.jar
    ## extract the extant manifest
    self.run_command( f"{self.c.jar_exe} -xvf {self.c.junit_tainted_jar} META-INF/MANIFEST.MF")

    ## compose list of jar-files in WEB-INF/lib/*.jar
    lib_jars =glob.glob( os.path.join(self.c.web_inf_lib_dir, '*.jar'))

    buffer =io.StringIO()
    buffer.write('Class-Path: ')

    ## compose Class-Path for mainifest 
    ## (a. 70 char line, 
    ##  b. leading space ' ' indicates continuation line)
    
    offset =11
    maxlen =69
    newline =chr(10)
    space =chr(32)

    for jar_file_name in lib_jars:
      jar_file_name =jar_file_name.replace('\\', '/')
      jar_file_name +=' '
      for c in jar_file_name:
        buffer.write(c)
        offset +=1
        if (offset % maxlen) == 0:
          buffer.write(newline + space)
      #enf-for
    #end-for

    manifest_mf =os.path.join( self.temp_dir, 'META-INF', 'MANIFEST.MF')
    manifest_mf_temp_txt =os.path.join( self.c.temp_dir, 'manifest.mf.temp.txt')

    with open( manifest_mf_temp_txt, 'wt') as MANIFEST_MF_TEMP_TXT:
      with open( manifest_mf, 'rt' ) as MANIFEST_MF:
        for line in MANIFEST_MF:
          line =line.rstrip()

          if len(line) > 0:
            print(f"***line to manifest.mf.temp.txt :'{line}'")
            MANIFEST_MF_TEMP_TXT.write( line + newline)
      #end reader
      # write the classpath to the temp file too
      MANIFEST_MF_TEMP_TXT.write(buffer.getvalue())
      MANIFEST_MF_TEMP_TXT.write(newline) 
      MANIFEST_MF_TEMP_TXT.flush()
    #end writer

    # update MANIFEST.MF in taintedjar
    self.run_command( f"{self.c.jar_exe} -uvfm {self.c.junit_tainted_jar} {manifest_mf_temp_txt}")
    
    os.chdir( self.c.curr_dir)

    return rval
  #end-method 

  def run_test_class(self):
    classpath =self.compose_classpath(self.c.test_classes_dir, self.c.classes_dir)
    classpath =classpath.replace('\\', '/')

    java_exe_cmd =f"{self.c.java_exe} -jar {self.c.junit_tainted_jar} execute -cp {classpath} --select-class {self.c.class_file_to_test}"
    rval =self.run_command( java_exe_cmd )
    return rval
  #
#end-class 'RunnerJunit'

if __name__ == "__main__":
  c =RunnerJunitConfig00()

  runner_junit =RunningJunit()
  runner_junit.configure( c )
  print( f"CONFIG:\n runner_junit.c =f{runner_junit.c}\n\n\n")

  runner_junit.run()







