# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk/asterisk-1.0.5.ebuild,v 1.2 2005/01/31 19:19:36 gustavoz Exp $

IUSE="alsa doc gtk mmx mysql pri zaptel uclibc resperl debug"

inherit eutils

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="ftp://ftp.asterisk.org/pub/telephony/asterisk/${P}.tar.gz
	 ftp://ftp.asterisk.org/pub/telephony/asterisk/${PN}-addons-1.0.4.tar.gz
	 ftp://ftp.asterisk.org/pub/telephony/asterisk/${PN}-sounds-1.0.1.tar.gz"

S=${WORKDIR}/${P}
S_ADDONS=${WORKDIR}/${PN}-addons-1.0.4
S_SOUNDS=${WORKDIR}/${PN}-sounds-1.0.1

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"

DEPEND="dev-libs/newt
	media-sound/mpg123
	media-sound/sox
	doc? ( app-doc/doxygen )
	gtk? ( =x11-libs/gtk+-1.2* )
	pri? ( >=net-libs/libpri-1.0.3 )
	alsa? ( media-libs/alsa-lib )
	mysql? ( dev-db/mysql )
	uclibc? ( sys-libs/uclibc )
	zaptel? ( >=net-misc/zaptel-1.0.3 )
	resperl? ( dev-lang/perl
		   >=net-misc/zaptel-1.0.3 )"


changes_message() {
	ewarn "Important changes since 1.0.0:"
	ewarn ""
	ewarn "- Voicemail Webapp has been removed!"
	ewarn "  (files are in /usr/share/doc/${PF}/cgi/ if you really need them)"
	ewarn ""
	ewarn "- Zaptel and PRI support are now disabled by default (see emerge -pv asterisk)"
	ewarn ""
	ewarn "- Support for embedded perl in the extensions file has been added"
	ewarn "  (res_perl from asterisk-addons; \"resperl\" use-flag)"
	ewarn ""
	ewarn "- Should build with uclibc now (untested / experimental)"
	ewarn ""
}

pkg_setup() {
	changes_message
	ebeep
	epause 10

	einfo "Running some pre-flight checks..."
	if use resperl; then
		# res_perl pre-flight check...
		if ! $(perl -V | grep -q "usemultiplicity=define"); then
			eerror "Embedded perl add-on needs Perl with built-in threads support"
			eerror "(rebuild perl with ithreads use-flag enabled)"
			die "Perl w/o threads support..."
		fi
		einfo "Perl with ithreads support found"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# set cflags & mmx optimization
	sed -i -e "s:^\(OPTIMIZE+=\).*:\1 ${CFLAGS}:" Makefile
	# asterisk wants to set -march itself
	sed -i -e "s:^\(CFLAGS+=\$(shell if \$(CC)\):#\1:" Makefile
	# gsm codec still uses -fomit-frame-pointer, and other codecs have their
	# own flags. We only change the arch.
	sed -i -e "s:^OPTIMIZE+=.*:OPTIMIZE+=${CFLAGS}:" codecs/gsm/Makefile

	if use mmx; then
		einfo "enabling mmx optimization"
		sed -i -e "s:^#\(K6OPT.*\):\1:" Makefile
	fi

	if ! use debug; then
		einfo "disabling debugging"
		sed -i -e "s:^\(DEBUG=\):#\1:" Makefile
	fi

	# change image path in voicemail cgi
	sed -i -e "s:^\(\$astpath = \).*:\1 \"/asterisk\";:" contrib/scripts/vmail.cgi

	#
	# embedded perl
	#
	if use resperl; then
		einfo "Patching asterisk for embedded perl support..."
		epatch ${S_ADDONS}/res_perl/astmake.diff

		# create necessary .c file
		perl -MExtUtils::Embed -e xsinit || die "Could not create perlxsi.c"

		sed -i -e "s:/usr/local/bin/perl:/usr/bin/perl:" \
			${S_ADDONS}/res_perl/Makefile \
			Makefile
		sed -i -e "s:^ASTSRC.*:ASTSRC = ${S}:" \
			-e "s:\$(ASTLIBDIR)/modules/\(res_musiconhold.so\):${S}/res/\1:" \
			${S_ADDONS}/res_perl/Makefile

## needs more testing...
#		# move perl stuff into /usr/lib/asterisk and symlink it
#		# with /etc/asterisk/perl (solves config protection trouble)
#		sed -i -e "s:\$(ASTETCDIR)/perl:\$(ASTLIBDIR)/perl:g" \
#			-e "s:\(mkdir \$(ASTLIBDIR)/perl \):\1; ln -s \$(subst \$(INSTALL_PREFIX),,\$(ASTLIBDIR))/perl \$(ASTETCDIR)/perl :" \
#			${S_ADDONS}/res_perl/Makefile
	fi

	#
	# uclibc patch
	#
	if use uclibc; then
		einfo "Patching asterisk for uclibc..."
		epatch ${FILESDIR}/1.0.0/asterisk-uclibc-dns.diff
	fi

	#
	# other patches
	#

	#
	# asterisk add-ons
	#
	cd ${S_ADDONS}
	sed -i -e "s:^OPTIMIZE+=.*:OPTIMIZE+=${CFLAGS}:" format_mp3/Makefile
	sed -i -e "s:^\(CFLAGS=\)\(.*\):\1-I${S}/include \2:" format_mp3/Makefile
	sed -i -e "s:-I../asterisk:-I${S} -I${S}/include:" Makefile
}

src_compile() {
	# build asterisk first...
	einfo "Building Asterisk..."
	cd ${S}
	emake -j1 || die "Make failed"

	#
	# add-ons
	#
	einfo "Building additional stuff..."
	cd ${S_ADDONS}
	emake -j1 || die "Make failed"

	if use resperl; then
		cd ${S_ADDONS}/res_perl
		emake -j1 || die "Building embedded perl failed"
	fi
}

src_install() {
	emake -j1 DESTDIR=${D} install || die "Make install failed"
	emake -j1 DESTDIR=${D} samples || die "Make install samples failed"

	# install addmailbox and astgenkey
	dosbin contrib/scripts/addmailbox
	dosbin contrib/scripts/astgenkey

	# documentation
	use doc && \
		emake -j1 DESTDIR=${D} progdocs

	# install necessary files
	dodir /etc/env.d
	echo "LD_LIBRARY_PATH=\"/usr/lib/asterisk\"" > ${D}/etc/env.d/25asterisk

	exeinto /etc/init.d
	newexe  ${FILESDIR}/1.0.0/asterisk.rc6 asterisk

	insinto /etc/conf.d
	newins  ${FILESDIR}/1.0.0/asterisk.confd asterisk

	# don't delete these, even if they are empty
	keepdir /var/spool/asterisk/voicemail/default/1234/INBOX
	keepdir /var/log/asterisk/cdr-csv

	# install standard docs...
	dodoc BUGS CREDITS LICENSE ChangeLog HARDWARE README README.fpm SECURITY

	docinto scripts
	dodoc contrib/scripts/*
	docinto firmware/iax
	dodoc contrib/firmware/iax/*

	insinto /usr/share/doc/${PF}/cgi
	doins contrib/scripts/vmail.cgi
	for i in "images/*.gif"; do
		doins $i
	done

	#
	# sounds + add-ons
	#

	# install additional sounds...
	einfo "Installing additional sounds..."
	cd ${S_SOUNDS}
	emake -j1 DESTDIR=${D} install || die "Make install failed"

	# install additional modules...
	einfo "Installing additional modules..."
	cd ${S_ADDONS}
	emake -j1 INSTALL_PREFIX=${D} install || die "Make install failed"

	if use resperl; then
		cd ${S_ADDONS}/res_perl
		emake -j1 INSTALL_PREFIX=${D} install || die "Installation of perl AST_API failed"
	fi
}

pkg_postinst() {
	einfo "Asterisk has been installed"
	einfo ""
	einfo "to add new Mailboxes use: /usr/sbin/addmailbox"
	einfo ""
	einfo "If you want to know more about asterisk, visit these sites:"
	einfo "http://www.automated.it/guidetoasterisk.htm"
	einfo "http://asterisk.xvoip.com/"
	einfo "http://www.voip-info.org/wiki-Asterisk"
	einfo "http://ns1.jnetdns.de/jn/relaunch/asterisk/"
	echo

	changes_message
}
