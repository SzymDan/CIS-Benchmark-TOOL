#!/bin/bash
#Funkcje uzywane w programie

function passed () {
	echo "Result: Test passed"
}

function failed () {
	echo "Result: Test failed"
}

#3.5.1.3 Ensure ufw service is enabled
echo "3.5.1.3 Ensure ufw service is enabled"
#Test Start#
if [[ $(systemctl is-enabled ufw) = "enabled" ]] && [[ $(ufw status | grep Status) = "Status: active" ]]; then
	passed
else
	failed
fi
#Test End#

#3.5.1.7 Ensure default deny firewall policy
echo "3.5.1.7 Ensure default deny firewall policy"
#Test Start#
if [[ $(ufw status verbose | grep "deny (incoming), deny (outgoing), deny (routed)") ]]; then
	passed
else
	failed
fi

#################SEKCJA 4.1.1#####################

#4.1.1.1 Ensure auditd is installed
echo "4.1.1.1 Ensure auditd is installed"
#Test start#
if [[ $(dpkg -s auditd audispd-plugins | grep "Status: install ok installed") ]]; then
	passed
else
	failed
fi
#Test end#

#4.1.1.2
echo "4.1.1.2 Ensure auditd service is enabled"
#Test start#
if [ $(systemctl is-enabled auditd) = "enabled" ]; then
	passed
else
	failed
fi
#Test end#

#4.1.1.3 Ensure auditing for processes that start prior to audit is enabled
echo "4.1.1.3 Ensure auditing for processes that start prior to audit is enabled"
#Test start#
if [[ $(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "audit=1" | wc -l) -eq 0 ]]; then
	passed
else
	failed
fi
#Test end#

#4.1.1.4 Ensure audit_backlog_limit is sufficient
echo "4.1.1.4 Ensure audit_backlog_limit is sufficient"
#Test start#
if [[ $(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "audit_backlog_limit=" | wc -l) -eq 0 ]]; then
	passed
else
	failed
fi
#Test end#

##############SEKCJA 4.1.2 Configure Data Retention####################

#4.1.2.1 Ensure audit log storage size is configured
echo "4.1.2.1 Ensure audit log storage size is configured"
#Test start#
if [[ $(grep -c '^max_log_file = [0-9]*' /etc/audit/auditd.conf) -eq 1 ]]; then
	passed
else
	failed
fi
#Test end#

#4.1.2.2 Ensure audit logs are not automatically deleted
echo "4.1.2.2 Ensure audit logs are not automatically deleted"
#Test start#
if [[ $(grep -c '^max_log_file_action = keep_logs' /etc/audit/auditd.conf) -eq 1 ]]; then
	passed
else
	failed
fi
