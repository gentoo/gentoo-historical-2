# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/qmail-mysql/qmail-mysql-1.03-r2.ebuild,v 1.1 2000/12/15 09:17:20 jerry Exp $

P=qmail-mysql-1.03
A="qmail-1.03.tar.gz checkpassword-0.81.tar.gz"
A0=qmail-mysql.patch
A1=checkpassword-mysql.patch
S=${WORKDIR}/qmail-1.03
DESCRIPTION="QMail with MySQL Support"
SRC_URI="http://cr.yp.to/software/qmail-1.03.tar.gz
	 http://cr.yp.to/software/checkpassword-0.81.tar.gz"
HOMEPAHE="http://www.qmail.org iain.cx/unix/qmail/mysql.php"

PROVIDE="virtual/mta"

src_compile() {
  cd ${S}
  cp Makefile Makefile.orig
  sed -e "s:MYSQL_LIBS=.*:MYSQL_LIBS=/usr/lib/mysql/libmysqlclient.a -lm:" \
      -e "s:MYSQL_INCLUDE=.*:MYSQL_INCLUDE=-I/usr/include/mysql:" Makefile.orig > Makefile
  try make it man
  cd checkpassword-0.81
  cp Makefile Makefile.orig
  sed -e "s:MYSQL_LIBS=.*:MYSQL_LIBS=/usr/lib/mysql/libmysqlclient.a -lm:" \
      -e "s:MYSQL_INCLUDE=.*:MYSQL_INCLUDE=-I/usr/include/mysql:" Makefile.orig > Makefile
  try make it man
}

src_unpack() {
    unpack qmail-1.03.tar.gz
    cd ${S}
    gzip -dc ${O}/files/${A0} | patch -p0
    unpack checkpassword-0.81.tar.gz
    cd checkpassword-0.81
    gzip -dc ${O}/files/${A1} | patch -p0
}

doins2() {
  if [ ${#} -ne 1 ]
    then
        echo "${0}: one argument needed"
        return
    fi
    install $INSOPTIONS ${D}${1}
}            

src_install() {                 
	cd ${S}
	insopts -d -o root -g qmail -m 755
	doins2 /var/qmail
	doins2 /var/qmail/control
	doins2 /var/qmail/users
	doins2 /var/qmail/bin
	doins2 /var/qmail/boot
	doins2 /var/qmail/alias

	insopts -d -o qmailq -g qmail -m 750
	doins2 /var/qmail/queue
	doins2 /var/qmail/queue/todo
	insopts -d -o qmailq -g qmail -m 700
	doins2 /var/qmail/queue/pid
	doins2 /var/qmail/queue/intd
	insopts -d -o qmails -g qmail -m 700
	doins2 /var/qmail/queue/bounce

	insopts -d -o qmailq -g qmail -m 750
	doins2 /var/qmail/queue/mess
	for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
	do
	  doins2 /var/qmail/queue/mess/$i
        done

	insopts -d -o qmails -g qmail -m 700
	doins2 /var/qmail/queue/info
	doins2 /var/qmail/queue/local
	doins2 /var/qmail/queue/remote
	for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
	do
	  doins2 /var/qmail/queue/info/$i
	  doins2 /var/qmail/queue/local/$i
	  doins2 /var/qmail/queue/remote/$i
        done

	insopts -d -o qmailq -g qmail -m 750
	doins2 /var/qmail/queue/lock

	dd if=/dev/zero of=${D}/var/qmail/queue/lock/tcpto bs=1024 count=1
	fperms 644 /var/qmail/queue/lock/tcpto
	fowners qmailr.qmail /var/qmail/queue/lock/tcpto

	touch ${D}/var/qmail/queue/lock/sendmutex
	fperms 600 /var/qmail/queue/lock/sendmutex
	fowners qmails.qmail /var/qmail/queue/lock/sendmutex

	mkfifo ${D}/var/qmail/queue/lock/trigger
	fperms 622 /var/qmail/queue/lock/trigger
	fowners qmails.qmail /var/qmail/queue/lock/trigger

	insopts -o root -g qmail -m 755
	insinto /var/qmail/boot
	for i in home home+df proc proc+df binm1 binm1+df binm2 binm2+df binm3 binm3+df
	do
	  doins $i
	done

	into /usr
	dodoc FAQ UPGRADE SENDMAIL INSTALL* TEST* REMOVE* PIC* SECURITY ${O}/files/mysqldump
	dodoc SYSDEPS TARGETS THANKS THOUGHTS TODO VERSION
	insopts -o qmailq -g qmail -m 4711
	insinto /var/qmail/bin
	doins qmail-queue qmail-queue
	
	insopts -o root -g qmail -m 700
	for i in qmail-lspawn qmail-start qmail-newu qmail-newmrh
	do
	  doins $i
	done
	
	insopts -o root -g qmail -m 711
	for i in qmail-getpw qmail-local qmail-remote qmail-rspawn qmail-clean qmail-send splogger qmail-pw2u
	do
	  doins $i $i
	done

	insopts -o root -g qmail -m 755
	for i in qmail-inject predate datemail mailsubj qmail-showctl \
	qmail-qread qmail-qstat qmail-tcpto qmail-tcpok qmail-pop3d \
	qmail-popup qmail-qmqpc qmail-qmqpd qmail-qmtpd qmail-smtpd \
	sendmail tcp-env qreceipt qsmhook qbiff forward preline \
	condredirect bouncesaying except maildirmake maildir2mbox \
	maildirwatch qail elq pinq config-fast
	do
	  doins $i 
	done

	into /usr
	for i in addresses envelopes maildir mbox dot-qmail qmail-control \
	qmail-header qmail-log qmail-users tcp-environ 
	do
	  doman $i.5
	done

	for i in forward condredirect bouncesaying except maildirmake \
	maildir2mbox maildirwatch mailsubj qreceipt qbiff preline tcp-env
	do
	  doman $i.1
	done

	doman splogger.8
	for i in local lspawn getpw remote rspawn clean send start queue \
	inject showctl newmrh newu pw2u qread qstat tcpok tcpto pop3d \
	popup qmqpc qmqpd qmtpd smtpd command
	do
	  doman qmail-$i.8
	done

	insinto /etc/rc.d/init.d
	insopts -m755
	doins ${O}/files/qmail
	cd checkpassword-0.81
	into /
	dobin checkpassword
	into /usr
	doman checkpassword.8	
}

pkg_postinst() {

    ln -fs /var/qmail/bin/sendmail ${ROOT}/usr/lib/sendmail
    ln -fs /var/qmail/bin/sendmail ${ROOT}/usr/sbin/sendmail


    pushd ${ROOT}/var/qmail/alias
    touch .qmail-postmaster
    touch .qmail-mailer-daemon
    touch .qmail-root

    if [ ! -d ${ROOT}/var/qmail/alias/Maildir ] ; then
	${ROOT}/var/qmail/bin/maildirmake Maildir
    fi
    chown alias.qmail .qmail-*
    chown -R alias.qmail Maildir
    chmod 640 .qmail-*
    popd
}

pkg_config () {

    . ${ROOT}/var/db/pkg/install.config

cat <<__ENDE__ > ${ROOT}/var/qmail/control/sqlserver
server=${QmailSQLHost}
login=${QmailSQLuser}
password=${QmailSQLpass}
db=${QmailSQLdb}
__ENDE__

    ${ROOT}/usr/sbin/rc-update add qmail

    if [ ${ROOT} = "/" ] ; then

	if [ ! -f ${ROOT}/var/qmail/control/me ] ; then
	    ${ROOT}/var/qmail/bin/config-fast $QmailHost  
	fi

	if [ ! -d /var/mysql/$QmailSQLdb ] ; then
	    mysqladmin -p$MySQLpass create $QmailSQLdb
	    gzip -dc /usr/doc/qmail-mysql-1.03/mysqldump.gz | mysql -p$MySQLpass $QmailSQLdb 
	fi
    fi
}



