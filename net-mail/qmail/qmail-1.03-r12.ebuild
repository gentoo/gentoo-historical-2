# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/qmail/qmail-1.03-r12.ebuild,v 1.8 2003/09/02 09:02:01 robbat2 Exp $

inherit eutils

IUSE="ssl"
DESCRIPTION="A modern replacement for sendmail which uses maildirs and includes SSL/TLS, AUTH SMTP, and queue optimization"
HOMEPAGE="http://www.qmail.org/
	http://members.elysium.pl/brush/qmail-smtpd-auth/
	http://www.jedi.claranet.fr/qmail-tuning.html"
SRC_URI="mirror://qmail/qmail-1.03.tar.gz
	mirror://qmail/qmailqueue-patch
	http://qmail.null.dk/big-todo.103.patch
	http://www.jedi.claranet.fr/qmail-link-sync.patch
	mirror://qmail/big-concurrency.patch
	http://www.suspectclass.com/~sgifford/qmail/qmail-0.0.0.0.patch
	http://david.acz.org/software/sendmail-flagf.patch
	mirror://qmail/qmail-1.03-qmtpc.patch
	http://qmail.goof.com/qmail-smtpd-relay-reject
	mirror://gentoo/qmail-local-tabs.patch
  	http://www.shupp.org/patches/qmail-maildir++.patch
  	ftp://ftp.pipeline.com.au/pipeint/sources/linux/WebMail/qmail-date-localtime.patch.txt
  	ftp://ftp.pipeline.com.au/pipeint/sources/linux/WebMail/qmail-limit-bounce-size.patch.txt
	http://www.ckdhr.com/ckd/qmail-103.patch
	http://www.arda.homeunix.net/store/qmail/qregex-starttls-2way-auth.patch
	http://www.soffian.org/downloads/qmail/qmail-remote-auth-patch-doc.txt"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
DEPEND="virtual/glibc
	sys-apps/groff
	ssl? ( >=dev-libs/openssl-0.9.6g )
	>=net-mail/queue-fix-1.4-r1"

RDEPEND="!virtual/mta
	virtual/glibc
	>=sys-apps/ucspi-tcp-0.88
	>=sys-apps/daemontools-0.76-r1
	>=net-mail/checkpassword-0.90
	>=net-mail/cmd5checkpw-0.22
	>=net-mail/dot-forward-0.71
	>=net-mail/queue-fix-1.4-r1"

PROVIDE="virtual/mta
	 virtual/mda"

S=${WORKDIR}/${P}

src_unpack() {


	# unpack the initial stuff
	unpack ${P}.tar.gz 
	
	# This makes life easy
	EPATCH_OPTS="-d ${S}" 

	# this patch merges a few others already
	EPATCH_SINGLE_MSG="Adding SMTP AUTH (2 way), Qregex and STARTTLS support" \
	epatch ${DISTDIR}/qregex-starttls-2way-auth.patch
	
	# Fixes a problem when utilizing "morercpthosts"
	epatch ${FILESDIR}/${PV}-${PR}/smtp-auth-close3.patch

	# patch so an alternate queue processor can be used
	# i.e. - qmail-scanner
	EPATCH_SINGLE_MSG="Adding QMAILQUEUE support" \
	epatch ${DISTDIR}/qmailqueue-patch	

	# a patch for faster queue processing
	EPATCH_SINGLE_MSG="Patching for large queues" \
	epatch ${DISTDIR}/big-todo.103.patch

	# Support for remote hosts that have QMTP
	EPATCH_SINGLE_MSG="Adding support for remote QMTP hosts" \
	epatch ${DISTDIR}/qmail-1.03-qmtpc.patch

	# Large TCP DNS replies confuse it sometimes
	EPATCH_SINGLE_MSG="Adding support for oversize DNS" \
	epatch ${DISTDIR}/qmail-103.patch

	# Fix for tabs in .qmail bug noted at
	# http://www.ornl.gov/its/archives/mailing-lists/qmail/2000/10/msg00696.html
	# gentoo bug #24293 
	epatch ${DISTDIR}/qmail-local-tabs.patch

	# Account for Linux filesystems lack of a synchronus link()
	epatch ${DISTDIR}/qmail-link-sync.patch

	# Increase limits for large mail systems
	epatch ${DISTDIR}/big-concurrency.patch

	# Treat 0.0.0.0 as a local address
	epatch ${DISTDIR}/qmail-0.0.0.0.patch

	# Let the system decide how to define errno
	epatch ${FILESDIR}/${PV}-${PR}/errno.patch

	# make the qmail 'sendmail' binary behave like sendmail's for -f
	epatch ${DISTDIR}/sendmail-flagf.patch

	# Apply patch to make qmail-local and qmail-pop3d compatible with the
	# maildir++ quota system that is used by vpopmail and courier-imap
	epatch ${DISTDIR}/qmail-maildir++.patch
	# fix a typo in the patch
	epatch ${FILESDIR}/${PV}-${PR}/maildir-quota-fix.patch

	# Apply patch for local timestamps.
	# This will make the emails headers be written in localtime rather than GMT
	# If you really want, uncomment it yourself, as mail really should be in GMT
	epatch ${DISTDIR}/qmail-date-localtime.patch.txt
	
	# Apply patch to trim large bouncing messages down greatly reduces traffic
	# when multiple bounces occur (As in with spam)
	epatch ${DISTDIR}/qmail-limit-bounce-size.patch.txt
	
	#TODO TEST
	# Apply patch to add ESMTP SIZE support to qmail-smtpd
	# This helps your server to be able to reject excessively large messages
	# "up front", rather than waiting the whole message to arrive and then
	# bouncing it because it exceeded your databytes setting
	epatch ${FILESDIR}/${PV}-${PR}/qmail-smtpd-esmtp-size-gentoo.patch
	
	#TODO TEST
	# Reject some bad relaying attempts
	# gentoo bug #18064 
	epatch ${FILESDIR}/${PV}-${PR}/qmail-smtpd-relay-reject.gentoo.patch

	#TODO REDIFF
	# provide badrcptto support
	# as per bug #17283
	# patch re-diffed from original at http://sys.pro.br/files/badrcptto-morebadrcptto-accdias.diff.bz2
	# presently this breaks qmail so it is disabled
	#epatch ${FILESDIR}/${PV}-${PR}/badrcptto-morebadrcptto-accdias-gentoo

	echo -n "${CC} ${CFLAGS}" >${S}/conf-cc	
	use ssl && echo -n ' -DTLS' >>${S}/conf-cc
	echo -n "${CC} ${LDFLAGS}" > ${S}/conf-ld
	echo -n "500" > ${S}/conf-spawn

	# fix coreutils messup
	sed -re 's/(head|tail) (-[[:alpha:]][[:alnum:]]+)+ -([[:digit:]]+)/\1 \2 -n\3/g' -i ${S}/Makefile
	sed -re 's/(head|tail) -([[:digit:]]+)/\1 -n\2/g' -i ${S}/Makefile


}

src_compile() {
	emake it man || die
}

src_install() {
	
	einfo "Setting up directory hierarchy ..."

	diropts -m 755 -o root -g qmail
	dodir /var/qmail

	for i in bin boot control
	do
		dodir /var/qmail/${i}
	done

	keepdir /var/qmail/users

	diropts -m 755 -o alias -g qmail
	dodir /var/qmail/alias

	einfo "Installing the qmail software ..." 

	insopts -o root -g qmail -m 755
	insinto /var/qmail/boot
	doins home home+df proc proc+df binm1 binm1+df binm2 binm2+df binm3 binm3+df
 
	dodoc FAQ UPGRADE SENDMAIL INSTALL* TEST* REMOVE* PIC* SECURITY 
	dodoc SYSDEPS TARGETS THANKS THOUGHTS TODO VERSION README* ${DISTDIR}/qmail-remote-auth-patch-doc.txt

	insinto /var/qmail/bin
	insopts -o qmailq -g qmail -m 4711
	doins qmail-queue 
        
	insopts -o root -g qmail -m 700
	doins qmail-lspawn qmail-start qmail-newu qmail-newmrh
        
	insopts -o root -g qmail -m 711
	doins qmail-getpw qmail-local qmail-remote qmail-rspawn \
	qmail-clean qmail-send splogger qmail-pw2u
 
	insopts -o root -g qmail -m 755
	doins qmail-inject predate datemail mailsubj qmail-showctl \
	qmail-qread qmail-qstat qmail-tcpto qmail-tcpok qmail-pop3d \
	qmail-popup qmail-qmqpc qmail-qmqpd qmail-qmtpd qmail-smtpd \
	sendmail tcp-env qreceipt qsmhook qbiff forward preline \
	condredirect bouncesaying except maildirmake maildir2mbox \
	maildirwatch qail elq pinq config-fast 
	#doins qmail-newbrt

	into /usr
	einfo "Installing manpages"
	doman *.1 *.5 *.8

	# use the correct maildirmake
	# the courier-imap one has some extensions that are nicer
	[ -e /usr/bin/maildirmake ] && MAILDIRMAKE="/usr/bin/maildirmake" || MAILDIRMAKE="${D}/var/qmail/bin/maildirmake"

	einfo "Adding env.d entry for qmail"
	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/${PV}-${PR}/99qmail 

	einfo "Creating sendmail replacement ..."
	diropts -m 755
	dodir /usr/sbin /usr/lib
	dosym /var/qmail/bin/sendmail /usr/sbin/sendmail
	dosym /var/qmail/bin/sendmail /usr/lib/sendmail

	einfo "Setting up the default aliases ..."
	diropts -m 700 -o alias -g qmail
	${MAILDIRMAKE} ${D}/var/qmail/alias/.maildir
	# for good measure
	keepdir /var/qmail/alias/.maildir/{cur,new,tmp}

	for i in mailer-daemon postmaster root 
	do
		if [ ! -f ${ROOT}/var/qmail/alias/.qmail-${i} ]; then
			touch ${D}/var/qmail/alias/.qmail-${i}
			fowners alias.qmail /var/qmail/alias/.qmail-${i}
		fi
	done
 
	einfo "Setting up maildirs by default in the account skeleton ..."
	diropts -m 755 -o root -g root
	insinto /etc/skel
	${MAILDIRMAKE} ${D}/etc/skel/.maildir
	newins ${FILESDIR}/${PV}-${PR}/dot_qmail .qmail
	fperms 644 /etc/skel/.qmail
	# for good measure
	keepdir /etc/skel/.maildir/{cur,new,tmp} 

	einfo "Setting up all services (send, smtp, qmtp, qmqp, pop3) ..."
	insopts -o root -g root -m 755
	diropts -m 755 -o root -g root
	dodir /var/qmail/supervise

	for i in send smtpd qmtpd qmqpd pop3d; do
		insopts -o root -g root -m 755
		diropts -m 755 -o root -g root
		dodir /var/qmail/supervise/qmail-${i}{,/log}
		diropts -m 755 -o qmaill
		keepdir /var/log/qmail/qmail-${i}
		fperms +t /var/qmail/supervise/qmail-${i}{,/log}
		insinto /var/qmail/supervise/qmail-${i}
		newins ${FILESDIR}/${PV}-${PR}/run-qmail${i} run
		insinto /var/qmail/supervise/qmail-${i}/log
		newins ${FILESDIR}/${PV}-${PR}/run-qmail${i}log run
		insinto /etc
		[ -f ${FILESDIR}/tcp.${i}.sample ] && newins ${FILESDIR}/tcp.${i}.sample /etc/tcp.${i}
		for i in smtp qmtp qmqp pop3; do
			[ -f ${D}/etc/tcp.${i} ] && tcprules ${D}/etc/tcp.${i}.cdb ${D}/etc/.tcp.${i}.tmp < ${D}/etc/tcp.${i}
		done
	done
	
	einfo "Installing the qmail startup file ..."
	insinto /var/qmail
	insopts -o root -g root -m 755
	doins ${FILESDIR}/${PV}-${PR}/rc

	einfo "Installing the qmail control file ..."
	exeinto /var/qmail/bin
	insopts -o root -g root -m 755
	doexe ${FILESDIR}/${PV}-${PR}/qmail-control

	einfo "Insalling some stock configuration files"
	insinto /var/qmail/control
	insopts -o root -g root -m 644
	doins ${FILESDIR}/${PV}-${PR}/conf-*
	newins ${FILESDIR}/${PV}-${PR}/dot_qmail defaultdelivery

	einfo "Configuration sanity checker"
	into /var/qmail
	insopts -o root -g root -m 644
	dobin ${FILESDIR}/${PV}-${PR}/config-sanity-check

}

pkg_postinst() {

	einfo "Setting up the message queue hierarchy ..."
	# queue-fix makes life easy!
	/var/qmail/bin/queue-fix /var/qmail/queue >/dev/null 

	# use the correct maildirmake
	# the courier-imap one has some extensions that are nicer
	[ -e /usr/bin/maildirmake ] && MAILDIRMAKE="/usr/bin/maildirmake" || MAILDIRMAKE="${D}/var/qmail/bin/maildirmake"

	# make sure root can get some mail
	[ ! -d /root/.maildir ] && ${MAILDIRMAKE} /root/.maildir
	[ ! -e /root/.qmail ] && cp ${FILESDIR}/${PV}-${PR}/dot_qmail /root/.qmail
	[ -e /root/.qmail ] && chmod 644 /root/.qmail

	# for good measure
	env-update

	einfo "Please do not forget to run, the following syntax :"
	einfo "ebuild /var/db/pkg/${CATEGORY}/${PN}-${PV}-${PR}/${PN}-${PV}-${PR}.ebuild config"
	einfo "This will setup qmail to run out-of-the-box on your system."
	echo
	einfo "To start qmail at boot you have to enable the /etc/init.d/svscan rc file"
	einfo "and create the following links :"
	einfo "ln -s /var/qmail/supervise/qmail-send /service/qmail-send"
	einfo "ln -s /var/qmail/supervise/qmail-smtpd /service/qmail-smtpd"
	echo
	einfo "To start the pop3 server as well, create the following link :"
	einfo "ln -s /var/qmail/supervise/qmail-pop3d /service/qmail-pop3d"
	echo
	einfo "Additionally, the QMTP and QMQP protocols are supported, and can be started as:"
	einfo "ln -s /var/qmail/supervise/qmail-qmtpd /service/qmail-qmtpd"
	einfo "ln -s /var/qmail/supervise/qmail-qmqpd /service/qmail-qmqpd"
	echo 
	einfo "Additionally, if you wish to run qmail right now, you should run:"
	einfo "source /etc/profile"
}

pkg_config() {

	# avoid some weird locale problems
	export LC_ALL="C"

	if [ ${ROOT} = "/" ] ; then
		if [ ! -f ${ROOT}/var/qmail/control/me ] ; then
			export qhost=`hostname --fqdn`			
			${ROOT}/var/qmail/bin/config-fast $qhost 
		fi
	fi

	einfo "Accepting relaying by default from all ips configured on this machine."
	LOCALIPS=`/sbin/ifconfig  | grep inet | cut -d' ' -f 12 -s | cut -b 6-20`
	TCPSTRING=":allow,RELAYCLIENT=\"\",RBLSMTPD=\"\""
	for ip in $LOCALIPS; do
		echo "${ip}${TCPSTRING}" >> ${ROOT}/etc/tcp.smtp
		echo "${ip}${TCPSTRING}" >> ${ROOT}/etc/tcp.qmtp
		echo "${ip}${TCPSTRING}" >> ${ROOT}/etc/tcp.qmqp
	done

	for i in smtp qmtp qmqp pop3; do
		[ -f ${ROOT}/etc/tcp.${i} ] && tcprules ${ROOT}/etc/tcp.${i}.cdb ${ROOT}/etc/.tcp.${i}.tmp < ${ROOT}/etc/tcp.${i}
	done

	if use ssl && [ ! -f ${ROOT}/var/qmail/control/servercert.pem ]; then
		echo "Creating a self-signed ssl-cert:"
		/usr/bin/openssl req -new -x509 -nodes -out ${ROOT}/var/qmail/control/servercert.pem -days 366 -keyout ${ROOT}/var/qmail/control/servercert.pem
		chmod 640 ${ROOT}/var/qmail/control/servercert.pem
		chown qmaild.qmail ${ROOT}/var/qmail/control/servercert.pem
		ln -s /var/qmail/control/servercert.pem ${ROOT}/var/qmail/control/clientcert.pem

		einfo "If You want to have a signed cert, do the following:"
		einfo "openssl req -new -nodes -out req.pem \\"
		einfo "-keyout /var/qmail/control/servercert.pem"
		einfo "Send req.pem to your CA to obtain signed_req.pem, and do:"
		einfo "cat signed_req.pem >> /var/qmail/control/servercert.pem"
	fi
}
