[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")   


$defaultMachine='mssql01-pro.aws.enocloud.corp'
$defaultPort='1433'
$Form = New-Object System.Windows.Forms.Form          
$Form.Size = New-Object System.Drawing.Size(600,400)
$Form.Text ="Port check"
$Form.SizeGripStyle = [System.Windows.Forms.SizeGripStyle]::Hide

############################################## function ##############################################		 

function Test_NetConnection 
{
$Result = Test-NetConnection $InputBox.text -Port $InputBox2.text | Out-String
$outputBox.text = $Result

}

############################################## InputBox, OutputBox, FormLabel ##############################################

$InputBox = New-Object System.Windows.Forms.TextBox            
$InputBox.Location = New-Object System.Drawing.Size(20,50)   
$InputBox.Size = New-Object System.Drawing.Size(250,20)  
$InputBox.Text = $defaultMachine
$Form.Controls.Add($InputBox)                                  

$InputBox2 = New-Object System.Windows.Forms.TextBox           
$InputBox2.Location = New-Object System.Drawing.Size(280,50)    
$InputBox2.Size = New-Object System.Drawing.Size(60,20)      
$InputBox2.Text = $defaultPort

$Form.Controls.Add($InputBox2)

$outputBox = New-Object System.Windows.Forms.TextBox           
$outputBox.Location = New-Object System.Drawing.Size(10,130)   
$outputBox.Size = New-Object System.Drawing.Size(565,200)      
$outputBox.MultiLine = $True                                   
$outputBox.ScrollBars = "Vertical" 			                  
$outputBox.ReadOnly = $True                                    
$outputBox.BackColor = "#042261"                               
$outputBox.ForeColor ="#FDFEFE"                               
$Form.Controls.Add($outputBox)                               

$FormLabel1 = New-Object System.Windows.Forms.Label
$FormLabel1.Text = "Server:"
$FormLabel1.ForeColor = "#000000"
$FormLabel1.Font = "Microsoft Sans Serif,8"
$FormLabel1.Location = New-Object System.Drawing.Point(20,30)
$FormLabel1.AutoSize = $true
$Form.Controls.Add($FormLabel1)

$FormLabel1 = New-Object System.Windows.Forms.Label
$FormLabel1.Text = "Port:"
$FormLabel1.ForeColor = "#000000"
$FormLabel1.Font = "Microsoft Sans Serif,8"
$FormLabel1.Location = New-Object System.Drawing.Point(280,30)
$FormLabel1.AutoSize = $true
$Form.Controls.Add($FormLabel1)

$Button = New-Object System.Windows.Forms.Button              
$Button.Location = New-Object System.Drawing.Size(400,30)     
$Button.Size = New-Object System.Drawing.Size(110,50)         
$Button.Text = "Start"                                        
$Button.Add_Click({Test_NetConnection})                         
$Form.Controls.Add($Button)                                    

#############################################################################################################

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
