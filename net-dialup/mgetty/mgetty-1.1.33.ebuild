# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mgetty/mgetty-1.1.33.ebuild,v 1.1 2005/04/19 20:43:50 mrness Exp $

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="Fax and Voice modem programs."
SRC_URI="ftp://alpha.greenie.net/pub/mgetty/source/1.1/${PN}${PV}-Apr10.tar.gz"
HOMEPAGE="http://alpha.greenie.net/mgetty/"

RDEPEND="virtual/libc"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4*
	doc? ( virtual/tetex )
	sys-apps/gawk
	sys-apps/groff
	dev-lang/perl
	sys-apps/texinfo"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~alpha ~ia64 ~hppa ~ppc ~amd64 ~mips"
IUSE="doc"

pkg_setup() {
	enewgroup fax
	enewuser fax -1 /bin/false /dev/null fax
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	# fix deprecate warnings
	epatch ${FILESDIR}/${P}-strerror.diff
	# add callback install to Makefile
	epatch ${FILESDIR}/${P}-callback.diff
	# Lucent modem CallerID patch - bug #80366
	epatch ${FILESDIR}/Lucent.c.patch

	#Avoid "is setXid, dynamically linked and using lazy bindings" QA notices 
	append-ldflags "-Wl,-z,now"

	sed -i 's: \$(CFLAGS) -o faxq-helper faxq-helper.o: $(LDLAGS) -Wl,-z,now -o faxq-helper faxq-helper.o:' ${S}/fax/Makefile

	sed -e 's:var/log/mgetty:var/log/mgetty/mgetty:' \
		-e 's:var/log/sendfax:var/log/mgetty/sendfax:' \
		-e 's:\/\* \(\#define CNDFILE "dialin.config"\) \*\/:\1:' \
		-e 's:\(\#define FAX_NOTIFY_PROGRAM\).*:\1 "/etc/mgetty+sendfax/new_fax":' \
		${S}/policy.h-dist > ${S}/policy.h

	#Set proper owner:group
	sed -i -e "s:uucp:fax:g" ${S}/mgetty.cfg.in
	sed -i -e "s:phone_group phone:phone_group fax:g" \
		-e "s:phone_owner root:phone_owner fax:g" \
		-e "s/root.phone/fax:fax/g" ${S}/voice/voice.conf-dist

	# bug 44231 and remove move warning
	sed -e 's:ECHO="echo":ECHO="echo -e":' \
		-e "/mv -f \$(SBINDIR)/d" \
		-i ${S}/Makefile

	sed -e "/^doc-all:/s/mgetty.asc mgetty.info mgetty.dvi mgetty.ps/mgetty.info/" \
		-i ${S}/doc/Makefile
	if use doc; then
		sed -e "s:dvips -o mgetty.ps:dvips -M -o mgetty.ps:" \
			-e "s/^doc-all:/doc-all: mgetty.ps/" \
			-i ${S}/doc/Makefile
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
	dodir /var/log/mgetty
	dodir /usr/share/info

	make prefix=${D}/usr \
		INFODIR=${D}/usr/share/info \
		CONFDIR=${D}/etc/mgetty+sendfax \
		MAN1DIR=${D}/usr/share/man/man1 \
		MAN4DIR=${D}/usr/share/man/man4 \
		MAN5DIR=${D}/usr/share/man/man5 \
		MAN8DIR=${D}/usr/share/man/man8 \
		SBINDIR=${D}/usr/sbin \
		BINDIR=${D}/usr/bin \
		VOICE_DIR=${D}/var/spool/voice \
		PHONE_GROUP=fax \
		PHONE_PERMS=755 \
		spool=${D}/var/spool \
		install vgetty-install install-callback || die "make install failed."

	cd ${S}
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

	insinto /usr/share/"${PN}"
	doins -r patches frontends
	insinto /usr/share/"${PN}"/voice
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
	einfo "${ROOT}/var/spool/voice/.code and ${ROOT}/var/spool/voice/messages/Index"
	einfo "are not longer created by this automatically!"
}
