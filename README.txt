'Leavers' account detector plugin for Nagios
--------------------------------------------

Version 1.0.2
Last Modified: 2017-03-02

(c) 2009-2017 Gareth Randall
License: GNU GPL 3.0+  (see LICENSE file)

Description
-----------

When employees leave a company, sometimes computer accounts are
not deleted, meaning that they could become a security risk.

This plugin checks for accounts of users who have left, using
a central list of blacklisted usernames which is downloaded
from a webserver.

A blacklist of 'disallowed' users is retrieved from a web server
and compared to users that exist on the system. Users don't have
to be logged in at the time.


Before using
------------

Before using, either edit the DISALLOWED_USERS_URL line in the
check_leavers file, or ensure that you pass in the URL using
the -u command line option.


Typical configuration entries
-----------------------------

The following examples show the service configured as "leavers-service",
with a corresponding servicegroup of "compliance-services".
(The term "compliance" comes from banking security regulations.)


On the Nagios monitoring host:

define servicegroup{
   servicegroup_name    compliance-services     ; name of the service group
   alias                IT System Compliance Tests
   }

define service{
   name                         leavers-service ; service template name
   use                          generic-service ; Inherit default values
   servicegroups                compliance-services     ; service group
   check_interval               720             ; actively test every 12 hours
   retry_interval               60              ; but retry every hour if prob
   max_check_attempts           3               ; 3 rechecks max
   register                     1               ;
   }


To monitor a particular host "test-server1", use the following:

define service{
    use                         leavers-service
    host_name                   remote-server1
    service_description         Leavers Accounts
    check_command               check_nrpe!check_leavers!1 2 http://office-server.local/blacklist
    }


On the remote host "remote-server1":

The NRPE config file (e.g. /opt/nagios/etc/nrpe.cfg ) should contain:

command[check_leavers]=/opt/nagios/libexec/check_leavers -w $ARG1$ -c $ARG2$ $ARG3$



To monitor the host running the nagios server, the check_command changes slightly:

define service{
    use                         leavers-service
    host_name                   localhost
    service_description         Leavers Accounts
    check_command               check_leavers!1!2!http://office-server.local/blacklist
    }

define command{
    command_name                check_leavers
    command_line                $USER1$/check_leavers -w $ARG1$ -c $ARG2$ -u $ARG3$
    }


Disallowed Users File
---------------------

The format is simply a list of users, one entry per line.
Lines beginning with '#' are comments. Example:

# Users no longer in the building
rod
jane
freddy


Future Improvements
-------------------

To do: Could have an option to ignore blacklisted user accounts
if they are locked (that is, the user cannot log in) even if the
account itself is still on the system.

