# Install IDA on Docker

### Pre-requisites

* [Docker](https://docs.docker.com/install/)   
* [Docker Compose](https://docs.docker.com/compose/install/)  
* [IDA on Docker scripts](https://github.com/sdc-china/IDA-ondocker)   
* [IDA Package](https://ibm.ent.box.com/folder/49559338541)    

##### Notes:
- Your installation need to access internet. 
- IDA Docker installation only for DEV testing purpose.       
- We map the mysql volumn for the /var/mysql/demo_data directory for customer to backup the mysql database.     


### Procedure

1. Git clone [IDA-ondocker](https://github.com/sdc-china/IDA-ondocker) 

2. Manually copy the [mysql-connector-java-5.1.44.jar](http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.44/mysql-connector-java-5.1.44.jar) into the ida-web.war\WEB-INF\lib\ folder.You can get ida-web.war from  build folder into the release package.  

3. Copy the ida-web.war into the web folder from the docker package. Copy the schema-mysql.sql,data-mysql.sql script from release package into the mysql folder.   

    ![dockerpackage]
 
    
4. Update docker environment variable.Open the "docker-compose.yml" at "script" level folder.Replace the environment variables SERVER_HOST, HTTP_PORT and HTTPS_PORT with your actaul values. If your machine ip is float,we strongly suggest you to use domain name to instead ip address for SERVER_HOST setting.           

     ![dockerEnv]   
 
5. Run Docker compose build command,after that check docker images are generated or not.             

   ``` 
   docker-compose build
   ```    

6. Start the IDA,use below command to start    

   ``` 
   docker-compose -p ida up -d
   ```  
   You can launch the ida application through the url for https://yourip:yourhttpsport/ida     
   You can open the browser http://dockerhostIP:4444/grid/console to check selenium grid/node installation status.           
   
7.  The default setting is start one Selenium Hub with one Firefox nodes and one Chrome nodes.Run below command to scale  firefox and chrome node.You can check the gride node number from the web console.       

    ```  
    docker-compose scale chrome=3 firefox=3
    ```          
    ![seleniumNode]        
8. Stop the IDA   
  
You can stop the ida use docker-compose down command.   

   ``` 
   docker-compose down 
   ```  
### Debug Selenium Container with RealVNC Viewer

Sometimes you want to troubleshooting the selenium backend browser running status,you can use below procedures to do that.

1. You can download the [real-vnc](https://www.realvnc.com/en/connect/download/viewer). and Install as per your operating system.  
2. Check  the selenium container we should verify the Container Process and Port Details. Use below command to check selenium port.
 
   ``` 
   docker ps|grep  selenium
   ```      
   ![seleniumPort]   
   You can acquire the port by looking at the container details Like from the Image above we can see the VNC server is listening on the port no 5906 .    
  
3. Open real VNC viewer,connect with docker ip and port no 

    ![vncviewer]  
    
4. When you are prompted for the password please enter your password.     
5. Running Our Test on the correct Port number will Open the Google in our Container and We can see the Browser running in our VNC Server.   
    ![vncviewerbrowser] 
    
[dockerpackage]: images/dockerpackage.png 
[seleniumNode]: images/selenium_node.png
[dockerEnv]: images/dockerenv.png
[seleniumPort]: images/seleniumgrid.png
[vncviewer]: images/vncviewer.png
[vncviewerbrowser]: images/vnc-view-browser.png
