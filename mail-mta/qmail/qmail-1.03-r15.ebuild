# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/qmail/qmail-1.03-r15.ebuild,v 1.18 2005/01/10 18:43:54 hansmi Exp $

inherit toolchain-funcs eutils fixheadtails

IUSE="ssl noauthcram notlsbeforeauth"
DESCRIPTION="A modern replacement for sendmail which uses maildirs and includes SSL/TLS, AUTH SMTP, and queue optimization"
HOMEPAGE="http://www.qmail.org/
	http://members.elysium.pl/brush/qmail-smtpd-auth/
	http://www.jedi.claranet.fr/qmail-tuning.html"
SRC_URI="mirror://qmail/${P}.tar.gz
	mirror://qmail/qmailqueue-patch
	http://qmail.null.dk/big-todo.103.patch
	http://www.jedi.claranet.fr/qmail-link-sync.patch
	mirror://qmail/big-concurrency.patch
	http://www.suspectclass.com/~sgifford/qmail/qmail-1.03-0.0.0.0-0.2.patch
	http://david.acz.org/software/sendmail-flagf.patch
	mirror://qmail/qmail-1.03-qmtpc.patch
	mirror://qmail/qmail-smtpd-relay-reject
	mirror://gentoo/qmail-local-tabs.patch
	http://www.shupp.org/patches/qmail-maildir++.patch
	ftp://ftp.pipeline.com.au/pipeint/sources/linux/WebMail/qmail-date-localtime.patch.txt
	ftp://ftp.pipeline.com.au/pipeint/sources/linux/WebMail/qmail-limit-bounce-size.patch.txt
	http://www.ckdhr.com/ckd/qmail-103.patch
	http://www.arda.homeunix.net/store/old_software/qregex-starttls-2way-auth.patch
	http://www.soffian.org/downloads/qmail/qmail-remote-auth-patch-doc.txt
	mirror://gentoo/qmail-gentoo-1.03-r12-badrcptto-morebadrcptto-accdias.diff.bz2
	http://www.dataloss.nl/software/patches/qmail-popupnofd2close.patch
	http://js.hu/package/qmail/qmail-1.03-reread-concurrency.2.patch
	http://www.mcmilk.de/qmail/dl/djb-qmail/patches/08-capa.diff
	http://www.leverton.org/qmail-hold-1.03.pat.gz
	mirror://qmail/netscape-progress.patch
	http://www-dt.e-technik.uni-dortmund.de/~ma/djb/qmail/sendmail-ignore-N.patch
	mirror://gentoo/qmail-1.03-moreipme-0.6pre1-gentoo.patch
	http://hansmi.ch/download/qmail/qmail-relaymxlookup-0.3.diff
	"
# broken stuffs
#http://www.qcc.ca/~charlesc/software/misc/nullenvsender-recipcount.patch

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc mips alpha arm hppa amd64 ia64"

DEPEND="virtual/libc
	sys-apps/groff
	ssl? ( >=dev-libs/openssl-0.9.6g )
	>=net-mail/queue-fix-1.4-r1"
RDEPEND="!virtual/mta
	virtual/libc
	app-shells/bash
	>=sys-apps/ucspi-tcp-0.88
	>=sys-apps/daemontools-0.76-r1
	>=net-mail/checkpassword-0.90
	>=net-mail/cmd5checkpw-0.22
	>=net-mail/dot-forward-0.71
	>=net-mail/queue-fix-1.4-r1
	selinux? ( sec-policy/selinux-qmail )"

PROVIDE="virtual/mta
	 virtual/mda"

#MY_PVR=${PVR}
MY_PVR=${PV}-r14

TCPRULES_DIR=/etc/tcprules.d

src_unpack() {
	# unpack the initial stuff
	unpack ${P}.tar.gz

	# This makes life easy
	EPATCH_OPTS="-d ${S}"

	# this patch merges a few others already
	EPATCH_SINGLE_MSG="Adding SMTP AUTH (2 way), Qregex and STARTTLS support" \
	epatch ${DISTDIR}/qregex-starttls-2way-auth.patch
	# bug #30570
	EPATCH_SINGLE_MSG="Fixing a memory leak in Qregex support" \
	epatch ${FILESDIR}/${MY_PVR}/qmail-1.03-qregex-memleak-fix.patch

	# Fixes a problem when utilizing "morercpthosts"
	epatch ${FILESDIR}/${MY_PVR}/smtp-auth-close3.patch

	# patch so an alternate queue processor can be used
	# i.e. - qmail-scanner
	EPATCH_SINGLE_MSG="Adding QMAILQUEUE support" \
	epatch ${DISTDIR}/qmailqueue-patch
	EPATCH_SINGLE_MSG="Adding QMAILQUEUE info to documentation" \
	epatch ${FILESDIR}/${MY_PVR}/qmail-qmailqueue-docs.patch

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
	epatch ${DISTDIR}/qmail-1.03-0.0.0.0-0.2.patch

	# Let the system decide how to define errno
	epatch ${FILESDIR}/errno.patch

	# holdremote support
	# pre-process to remove the header added upstream
	zcat ${DISTDIR}/qmail-hold-1.03.pat.gz | sed '123,150d' >${T}/qmail-hold-1.03.patch
	epatch ${T}/qmail-hold-1.03.patch

	# make the qmail 'sendmail' binary behave like sendmail's for -f
	epatch ${DISTDIR}/sendmail-flagf.patch

	# Apply patch to make qmail-local and qmail-pop3d compatible with the
	# maildir++ quota system that is used by vpopmail and courier-imap
	epatch ${DISTDIR}/qmail-maildir++.patch
	# fix a typo in the patch
	# upstream has changed the patch and this isn't needed anymore
	#epatch ${FILESDIR}/${MY_PVR}/maildir-quota-fix.patch

	# Apply patch for local timestamps.
	# This will make the emails headers be written in localtime rather than GMT
	# If you really want, uncomment it yourself, as mail really should be in GMT
	epatch ${DISTDIR}/qmail-date-localtime.patch.txt

	# Apply patch to trim large bouncing messages down greatly reduces traffic
	# when multiple bounces occur (As in with spam)
	epatch ${DISTDIR}/qmail-limit-bounce-size.patch.txt

	# Apply patch to add ESMTP SIZE support to qmail-smtpd
	# This helps your server to be able to reject excessively large messages
	# "up front", rather than waiting the whole message to arrive and then
	# bouncing it because it exceeded your databytes setting
	epatch ${FILESDIR}/${MY_PVR}/qmail-smtpd-esmtp-size-gentoo.patch

	#TODO TEST
	# Reject some bad relaying attempts
	# gentoo bug #18064
	epatch ${FILESDIR}/${MY_PVR}/qmail-smtpd-relay-reject.gentoo.patch

	#TODO TEST HEAVILY AS THIS PATCH WAS CUSTOM FIXED
	# provide badrcptto support
	# as per bug #17283
	# patch re-diffed from original at http://sys.pro.br/files/badrcptto-morebadrcptto-accdias.diff.bz2
	epatch ${DISTDIR}/qmail-gentoo-1.03-r12-badrcptto-morebadrcptto-accdias.diff.bz2

	# bug #31426
	# original submission by shadow@ines.ro, cleaned up by robbat2@gentoo.org
	# only allows AUTH after STARTTLS, if compiled TLS && TLS_BEFORE_AUTH defines
	epatch ${FILESDIR}/${MY_PVR}/auth-after-tls-only.patch

	EPATCH_SINGLE_MSG="Enable stderr logging from checkpassword programs" \
	epatch ${DISTDIR}/qmail-popupnofd2close.patch
	EPATCH_SINGLE_MSG="Allow qmail to re-read concurrency limits on HUP" \
	epatch ${DISTDIR}/qmail-1.03-reread-concurrency.2.patch
	EPATCH_SINGLE_MSG="Add support for CAPA in POP3d" \
	epatch ${DISTDIR}/08-capa.diff
	EPATCH_SINGLE_MSG="Fixing output bug in CAPA-enabled POP3d" \
	epatch ${FILESDIR}/${MY_PVR}/qmail-pop3d-capa-outputfix.patch
	EPATCH_SINGLE_MSG="Fixing netscape progress bar bug with POP3d" \
	epatch ${DISTDIR}/netscape-progress.patch

	EPATCH_SINGLE_MSG="Making the sendmail binary ignore -N options for compatibility" \
	epatch ${DISTDIR}/sendmail-ignore-N.patch

	# rediff of original at http://www.qmail.org/accept-5xx.patch
	epatch ${FILESDIR}/${MY_PVR}/qmail-1.03-accept-5xx.tls.patch

	# rediffed from original at http://www.qcc.ca/~charlesc/software/misc/nullenvsender-recipcount.patch
	# because of TLS
	EPATCH_SINGLE_MSG="Refuse messages from the null envelope sender if they have more than one envelope recipient" \
	epatch ${FILESDIR}/${MY_PVR}/nullenvsender-recipcount.tls.patch

	# rediffed from original at http://www.dataloss.nl/software/patches/qmail-pop3d-stat.patch
	# because of TLS
	EPATCH_SINGLE_MSG="qmail-pop3d reports erroneous figures on STAT after a DELE" \
	epatch ${FILESDIR}/${MY_PVR}/qmail-pop3d-stat.tls.patch

	EPATCH_SINGLE_MSG="Branding qmail with Gentoo identifier 'Gentoo Linux ${PF}'" \
	epatch ${FILESDIR}/${MY_PVR}/qmail-gentoo-branding.patch
	sed -e "s/__PF__/${PF}/" -i ${S}/qmail-smtpd.c

	EPATCH_SINGLE_MSG="qmail-pop3d fix for top output so Evolution doesn't barf" \
	epatch ${FILESDIR}/${PVR}/qmail-pop3d-top-outputfix.patch

	# Fix a compilation-error on Mac OS X
	# qmail doesn't run yet on Mac OS X, but this will help in the future
	if useq macos; then
		epatch ${FILESDIR}/${PVR}/qmail-macos-dns-fix.patch
	fi

	# Rediffed patch to prevent from a problem which can
	# happen when using NAT. Rediffed by hansmi@gentoo.org.
	# See http://www.suspectclass.com/~sgifford/qmail/qmail-moreipme-0.6.README
	epatch ${DISTDIR}/qmail-1.03-moreipme-0.6pre1-gentoo.patch

	# Patch to look up the mx before relaying
	# Look at http://hansmi.ch/software/qmail
	epatch ${DISTDIR}/qmail-relaymxlookup-0.3.diff
	epatch ${FILESDIR}/${PVR}/Makefile-relaymxlookup.patch

	# Fix a bug on ia64, see bug 68173
	# Doesn't affect other platforms
	epatch ${FILESDIR}/${PVR}/spawn-alloc-h.patch

	# Fixes bug 40010
	EPATCH_SINGLE_MSG="Fixing broken #ifdef's to #if (TLS && TLS_BEFORE_AUTH)" \
	epatch ${FILESDIR}/${PVR}/tlsbeforeauth-fix.patch

	echo -n "$(tc-getCC) ${CFLAGS}" >${S}/conf-cc
	if use ssl; then
		einfo "Enabling SSL/TLS functionality"
		echo -n ' -DTLS ' >>${S}/conf-cc

		# from bug #31426
		if ! use notlsbeforeauth; then
			einfo "Enabling STARTTLS before SMTP AUTH"
			echo -n '-DTLS_BEFORE_AUTH ' >>${S}/conf-cc
		else
			einfo "Disabling STARTTLS before SMTP AUTH"
		fi

	fi

	# fix bug #33818
	if use noauthcram; then
		einfo "Disabling AUTHCRAM support"
		sed -e 's,^#define AUTHCRAM$,//&,' -i ${S}/qmail-smtpd.c
	else
		einfo "Enabling AUTHCRAM support"
	fi

	echo -n "$(tc-getCC) ${LDFLAGS}" > ${S}/conf-ld
	echo -n "500" > ${S}/conf-spawn

	# fix coreutils messup
	ht_fix_file ${S}/Makefile

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
	doins home home+df proc proc+df binm1 binm1+df binm2 \
		binm2+df binm3 binm3+df

	dodoc FAQ UPGRADE SENDMAIL INSTALL* TEST* REMOVE* PIC* SECURITY
	dodoc SYSDEPS TARGETS THANKS THOUGHTS TODO VERSION README* \
		${DISTDIR}/qmail-remote-auth-patch-doc.txt

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
	maildirwatch qail elq pinq config-fast qmail-newbrt

	into /usr
	einfo "Installing manpages"
	doman *.[1-8]

	# use the correct maildirmake
	# the courier-imap one has some extensions that are nicer
	[ -e /usr/bin/maildirmake ] && \
		MAILDIRMAKE="/usr/bin/maildirmake" || \
		MAILDIRMAKE="${D}/var/qmail/bin/maildirmake"

	einfo "Adding env.d entry for qmail"
	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/99qmail

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
			fowners alias:qmail /var/qmail/alias/.qmail-${i}
		fi
	done

	einfo "Setting up maildirs by default in the account skeleton ..."
	diropts -m 755 -o root -g root
	insinto /etc/skel
	newins ${FILESDIR}/dot_qmail .qmail.sample
	fperms 644 /etc/skel/.qmail.sample
	${MAILDIRMAKE} ${D}/etc/skel/.maildir
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
		newins ${FILESDIR}/run-qmail${i} run
		insinto /var/qmail/supervise/qmail-${i}/log
		newins ${FILESDIR}/run-qmail${i}log run
	done

	dodir ${TCPRULES_DIR}
	insinto ${TCPRULES_DIR}
	for i in smtp qmtp qmqp pop3; do
		newins ${FILESDIR}/tcp.${i}.sample tcp.qmail-${i}
	done

	einfo "Installing the qmail startup file ..."
	insinto /var/qmail
	insopts -o root -g root -m 755
	doins ${FILESDIR}/rc

	einfo "Insalling some stock configuration files"
	insinto /var/qmail/control
	insopts -o root -g root -m 644
	doins ${FILESDIR}/conf-*
	newins ${FILESDIR}/dot_qmail defaultdelivery
	use ssl && doins ${FILESDIR}/servercert.cnf

	einfo "Configuration sanity checker and launcher"
	into /var/qmail
	insopts -o root -g root -m 644
	dobin ${FILESDIR}/config-sanity-check
	dobin ${FILESDIR}/qmail-config-system

	if use ssl; then
		einfo "SSL Certificate creation script"
		dobin ${FILESDIR}/mkservercert
		einfo "RSA key generation cronjob"
		insinto /etc/cron.hourly
		doins ${FILESDIR}/qmail-genrsacert.sh
		chmod +x ${D}/etc/cron.hourly/qmail-genrsacert.sh

		# for some files
		keepdir /var/qmail/control/tlshosts/
	fi
}

rootmailfixup() {
	# so you can check mail as root easily
	local TMPCMD="ln -sf /var/qmail/alias/.maildir/ ${ROOT}/root/.maildir"
	if [ -d "${ROOT}/root/.maildir" ] && [ ! -L "${ROOT}/root/.maildir" ] ; then
		einfo "Previously the qmail ebuilds created /root/.maildir/ but not"
		einfo "every mail was delivered there. If the directory does not"
		einfo "contain any mail, please delete it and run:"
		einfo "${TMPCMD}"
	else
		${TMPCMD}
	fi
	chown -R alias:qmail ${ROOT}/var/qmail/alias/.maildir 2>/dev/null
}

buildtcprules() {
	for i in smtp qmtp qmqp pop3; do
		# please note that we don't check if it exists
		# as we want it to make the cdb files anyway!
		f=tcp.qmail-${i}
		src=${ROOT}${TCPRULES_DIR}/${f}
		cdb=${ROOT}${TCPRULES_DIR}/${f}.cdb
		tmp=${ROOT}${TCPRULES_DIR}/.${f}.tmp
		cat ${src} 2>/dev/null | tcprules ${cdb} ${tmp}
	done
}

pkg_postinst() {

	einfo "Setting up the message queue hierarchy ..."
	# queue-fix makes life easy!
	/var/qmail/bin/queue-fix ${ROOT}/var/qmail/queue >/dev/null

	rootmailfixup
	buildtcprules

	# for good measure
	env-update

	einfo "To setup qmail to run out-of-the-box on your system, run:"
	einfo "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	echo
	einfo "To start qmail at boot you have to add svscan to your startup"
	einfo "and create the following links:"
	einfo "ln -s /var/qmail/supervise/qmail-send /service/qmail-send"
	einfo "ln -s /var/qmail/supervise/qmail-smtpd /service/qmail-smtpd"
	echo
	einfo "To start the pop3 server as well, create the following link:"
	einfo "ln -s /var/qmail/supervise/qmail-pop3d /service/qmail-pop3d"
	echo
	einfo "Additionally, the QMTP and QMQP protocols are supported, "
	einfo "and can be started as:"
	einfo "ln -s /var/qmail/supervise/qmail-qmtpd /service/qmail-qmtpd"
	einfo "ln -s /var/qmail/supervise/qmail-qmqpd /service/qmail-qmqpd"
	echo
	einfo "Additionally, if you wish to run qmail right now, you should "
	einfo "run this before anything else:"
	einfo "source /etc/profile"
	echo
	einfo "If you are looking for documentation, check those links:"
	einfo "http://www.gentoo.org/doc/en/qmail-howto.xml"
	einfo "  -- qmail/vpopmail Virtual Mail Hosting System Guide"
	einfo "http://www.lifewithqmail.com/"
	einfo "  -- Life with qmail"
}

pkg_preinst() {
	mkdir -p ${TCPRULES_DIR}
	for proto in smtp qmtp qmqp pop3; do
		for ext in '' .cdb; do
			old="/etc/tcp.${proto}${ext}"
			new="${TCPRULES_DIR}/tcp.qmail-${proto}${ext}"
			fail=0
			if [ -f "$old" -a ! -f "$new" ]; then
				einfo "Moving $old to $new"
				cp $old $new || fail=1
			else
				fail=1
			fi
			if [ "${fail}" = "1" ]; then
				eerror "Error moving $old to $new, be sure to check the"
				eerror "configuration! You may have already moved the files,"
				eerror "in which case you can delete $old"
			fi
		done
	done
}

pkg_config() {

	# avoid some weird locale problems
	export LC_ALL="C"

	if [ ${ROOT} = "/" ] ; then
		if [ ! -f ${ROOT}var/qmail/control/me ] ; then
			export qhost=`hostname --fqdn`
			${ROOT}var/qmail/bin/config-fast $qhost
		fi
	else
		ewarn "Skipping some configuration as it MUST be run on the final host"
	fi

	einfo "Accepting relaying by default from all ips configured on this machine."
	LOCALIPS=`/sbin/ifconfig  | grep inet | cut -d' ' -f 12 -s | cut -b 6-20`
	TCPSTRING=":allow,RELAYCLIENT=\"\",RBLSMTPD=\"\""
	for ip in $LOCALIPS; do
		myline="${ip}${TCPSTRING}"
		for proto in smtp qmtp qmqp; do
			f="${ROOT}${TCPRULES_DIR}/tcp.qmail-${proto}"
			egrep -q "${myline}" ${f} || echo "${myline}" >>${f}
		done
	done

	buildtcprules

	if use ssl; then
		${ROOT}etc/cron.daily/qmail-genrsacert.sh
		einfo "Creating a self-signed ssl-certificate:"
		/var/qmail/bin/mkservercert
		einfo "If you want to have a properly signed certificate "
		einfo "instead, do the following:"
		einfo "openssl req -new -nodes -out req.pem \\"
		einfo "-config /var/qmail/control/servercert.cnf \\"
		einfo "-keyout /var/qmail/control/servercert.pem"
		einfo "Send req.pem to your CA to obtain signed_req.pem, and do:"
		einfo "cat signed_req.pem >> /var/qmail/control/servercert.pem"
	fi
}
