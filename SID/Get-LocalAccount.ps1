Get-WMIObject Win32_Account -Filter 'LocalAccount=true'

# Built-in accounts on a Windows 2012 R2 member servers
# name                                    SID                                    
#----                                    ---                                    
# Everyone                                S-1-1-0                                
# LOCAL                                   S-1-2-0                                
# CREATOR OWNER                           S-1-3-0                                
# CREATOR GROUP                           S-1-3-1                                
# CREATOR OWNER SERVER                    S-1-3-2                                
# CREATOR GROUP SERVER                    S-1-3-3                                
# OWNER RIGHTS                            S-1-3-4                                
# DIALUP                                  S-1-5-1                                
# NETWORK                                 S-1-5-2                                
# BATCH                                   S-1-5-3                                
# INTERACTIVE                             S-1-5-4                                
# SERVICE                                 S-1-5-6                                
# ANONYMOUS LOGON                         S-1-5-7                                
# PROXY                                   S-1-5-8                                
# SYSTEM                                  S-1-5-18                               
# ENTERPRISE DOMAIN CONTROLLERS           S-1-5-9                                
# SELF                                    S-1-5-10                               
# Authenticated Users                     S-1-5-11                               
# RESTRICTED                              S-1-5-12                               
# TERMINAL SERVER USER                    S-1-5-13                               
# REMOTE INTERACTIVE LOGON                S-1-5-14                               
# IUSR                                    S-1-5-17                               
# LOCAL SERVICE                           S-1-5-19                               
# NETWORK SERVICE                         S-1-5-20                               
# BUILTIN                                 S-1-5-32                               
# Access Control Assistance Operators     S-1-5-32-579                           
# Administrators                          S-1-5-32-544                           
# Backup Operators                        S-1-5-32-551                           
# Certificate Service DCOM Access         S-1-5-32-574                           
# Cryptographic Operators                 S-1-5-32-569                           
# Distributed COM Users                   S-1-5-32-562                           
# Event Log Readers                       S-1-5-32-573                           
# Guests                                  S-1-5-32-546                           
# Hyper-V Administrators                  S-1-5-32-578                           
# IIS_IUSRS                               S-1-5-32-568                           
# Network Configuration Operators         S-1-5-32-556                           
# Performance Log Users                   S-1-5-32-559                           
# Performance Monitor Users               S-1-5-32-558                           
# Power Users                             S-1-5-32-547                           
# Print Operators                         S-1-5-32-550                           
# RDS Endpoint Servers                    S-1-5-32-576                           
# RDS Management Servers                  S-1-5-32-577                           
# RDS Remote Access Servers               S-1-5-32-575                           
# Remote Desktop Users                    S-1-5-32-555                           
# Remote Management Users                 S-1-5-32-580                           
# Replicator                              S-1-5-32-552                           
# Users                                   S-1-5-32-545 
