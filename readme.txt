1. Download Windows 7 IE8 test image from:
http://www.microsoft.com/download/en/details.aspx?id=11575

2. Extract and run image - MS Virtual PC required

3. Modify settings of vmcx to enable integration with local storage device (hard drive)

4. Inside the virtual machine, goto Windows Features and turn on the following features:
* IIS (top level node)
* ASP.NET (IIS -> WWW Services -> App Dev Features -> ASP.NET)
* WCF HTTP Activation (under MS .NET Framework 3.5.1)
* WCF Non-HTTP Activation (under MS .NET Framework 3.5.1)

5. Download and install MS .NET 4 (only the client profile is installed by default)
http://www.microsoft.com/download/en/details.aspx?id=17851 Web-installer
http://www.microsoft.com/download/en/details.aspx?id=17718 Standalone installer

6. On the guest machine, open Powershell

7. Enable the execution of local scripts with the following command:
Set-ExecutionPolicy RemoteSigned

8. Copy the WASHost solution folder to the guest machine at the path c:\WASHosting

9. In Powershell, change directories to the folder you just created (e.g. 'cd c:\WASHosting')

10. In Powershell, run the following command (answer R for Run Once at any security prompts:)
.\Configure-IIS.ps1 -i

11. Execute 'iisreset' from the command prompt to restart IIS.

12. In the file explorer on the guest machine, navigate to c:\WASHosting\Client\bin\Release

13. Double-click Client.exe

14. Click the TCP button - you should see the following message appear as an alert (it may take a few seconds:)
Message 'Hello over TCP protocol with NetTcpBinding!' received at M/DD/YYYY hh:mm:ss AM|PM

15. Inside the virtual machine, goto Windows Features and turn OFF the following features:
* WCF HTTP Activation (under MS .NET Framework 3.5.1)
* WCF Non-HTTP Activation (under MS .NET Framework 3.5.1)

16. Inside the virtual machine, goto Windows Features and turn ON the following features:
* WCF HTTP Activation (under MS .NET Framework 3.5.1)
* WCF Non-HTTP Activation (under MS .NET Framework 3.5.1)

17. Click the TCP button - you should get an error:
The message could not be dispatched because the service at the endpoint address
'net.tcp://localhost:9000/HelloIndigoService.svc/netTcp' is unavailable for the
protocol of the address.

No amount of iisresetting or uninstalling and reinstalling the service/site/application/app pool will fix this
error.  The only workaround that I have found is to completely uninstall WAS and IIS and reinstall everything.
This blows away any IIS configuration that may exist on the machine making this a very painful workaround in 
production environments.

Both of the following features should be capable of being uninstalled/reinstalled without corrupting the IIS 
installation:
* WCF HTTP Activation (under MS .NET Framework 3.5.1)
* WCF Non-HTTP Activation (under MS .NET Framework 3.5.1)