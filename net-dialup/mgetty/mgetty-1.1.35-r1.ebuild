# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mgetty/mgetty-1.1.35-r1.ebuild,v 1.2 2006/05/24 20:18:34 hansmi Exp $

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="Fax and Voice modem programs."
SRC_URI="ftp://mgetty.greenie.net/pub/mgetty/source/1.1/${PN}${PV}-Feb22.tar.gz"
HOMEPAGE="http://mgetty.greenie.net/"

DEPEND="doc? ( virtual/tetex )
	>=sys-apps/sed-4
	sys-apps/gawk
	sys-apps/groff
	dev-lang/perl
	sys-apps/texinfo"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ppc sparc x86"
IUSE="doc"

pkg_setup() {
	enewgroup fax
	enewuser fax -1 -1 /dev/null fax
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-strerror.patch" # fix deprecate warnings
	epatch "${FILESDIR}/${P}-callback.patch" # add callback install to Makefile
	epatch "${FILESDIR}/Lucent.c.patch" # Lucent modem CallerID patch - bug #80366
	epatch "${FILESDIR}/${P}-faxrunq.patch"

	#Avoid "is setXid, dynamically linked and using lazy bindings" QA notices 
	append-ldflags $(bindnow-flags)

	sed -i 's: \$(CFLAGS) -o faxq-helper faxq-helper.o: $(LDLAGS) '$(bindnow-flags)' -o faxq-helper faxq-helper.o:' "${S}/fax/Makefile"

	sed -e 's:var/log/mgetty:var/log/mgetty/mgetty:' \
		-e 's:var/log/sendfax:var/log/mgetty/sendfax:' \
		-e 's:\/\* \(\#define CNDFILE "dialin.config"\) \*\/:\1:' \
		-e 's:\(\#define FAX_NOTIFY_PROGRAM\).*:\1 "/etc/mgetty+sendfax/new_fax":' \
		"${S}/policy.h-dist" > "${S}/policy.h"

	#Set proper owner:group
	sed -i -e "s:uucp:fax:g" "${S}/mgetty.cfg.in"
	sed -i -e "s:phone_group phone:phone_group fax:g" \
		-e "s:phone_owner root:phone_owner fax:g" \
		-e "s/root.phone/fax:fax/g" "${S}/voice/voice.conf-dist"

	# bug 44231 and remove move warning
	sed -e 's:ECHO="echo":ECHO="echo -e":' \
		-e "/mv -f \$(SBINDIR)/d" \
		-i "${S}/Makefile"

	sed -e "/^doc-all:/s/mgetty.asc mgetty.info mgetty.dvi mgetty.ps/mgetty.info/" \
		-i "${S}/doc/Makefile"
	if use doc; then
		sed -e "s:dvips -o mgetty.ps:dvips -M -o mgetty.ps:" \
			-e "s/^doc-all:/doc-all: mgetty.ps/" \
			-i "${S}/doc/Makefile"
	fi
}

src_compile() {
	append-flags "-DAUTO_PPP"

	# parallel make fix later - 'sedscript' issue
	make prefix=/usr \
		CC="$(tc-getCC)" \
		CONFDIR=/etc/mgetty+sendfax \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		all vgetty || die "make failed."
}

src_install () {
	dodir /var/spool
	keepdir /var/log/mgetty
	dodir /usr/share/info

	make prefix="${D}/usr" \
		INFODIR="${D}/usr/share/info" \
		CONFDIR="${D}/etc/mgetty+sendfax" \
		MAN1DIR="${D}/usr/share/man/man1" \
		MAN4DIR="${D}/usr/share/man/man4" \
		MAN5DIR="${D}/usr/share/man/man5" \
		MAN8DIR="${D}/usr/share/man/man8" \
		SBINDIR="${D}/usr/sbin" \
		BINDIR="${D}/usr/bin" \
		VOICE_DIR="${D}/var/spool/voice" \
		PHONE_GROUP=fax \
		PHONE_PERMS=755 \
		spool="${D}/var/spool" \
		install vgetty-install install-callback || die "make install failed."

	cd "${S}"
	dodoc BUGS ChangeLog README.1st Recommend THANKS TODO \
		doc/*.txt doc/modems.db || die "dodoc failed."
	doinfo doc/mgetty.info || die "doinfo failed."

	docinto vgetty
	dodoc voice/{Readme,Announce,ChangeLog,Credits} || die "vgetty voice failed."

	if use doc; then
		dodoc doc/mgetty.ps || die "mgetty.ps failed"
	fi

	docinto vgetty/doc
	dodoc voice/doc/*

	mv samples/new_fax.all samples_new_fax.all || die "move failed."
	docinto samples
	dodoc samples/*

	docinto samples/new_fax
	dodoc samples_new_fax.all/*

	insinto /usr/share/${PN}
	doins -r patches frontends
	insinto /usr/share/${PN}/voice
	doins -r voice/{contrib,Perl,scripts}

	diropts -m 0750 -o fax -g fax
	dodir /var/spool/voice
	keepdir /var/spool/voice/incoming
	keepdir /var/spool/voice/messages
	dodir /var/spool/fax
	dodir /var/spool/fax/outgoing
	keepdir /var/spool/fax/outgoing/locks
	keepdir /var/spool/fax/incoming
}

pkg_postinst() {
	einfo "Users who wish to use the fax or voicemail capabilities must be members"
	einfo "of the group fax in order to access files"
	echo
	einfo "If you want to grab voice messages from a remote location, you must save"
	einfo "the password in ${ROOT}var/spool/voice/.code file"
	echo
	ewarn "${ROOT}var/spool/voice/.code and ${ROOT}var/spool/voice/messages/Index"
	ewarn "are not longer created by this automatically!"
}
