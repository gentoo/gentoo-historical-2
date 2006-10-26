# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/silc-plugin/silc-plugin-1.0.1-r4.ebuild,v 1.5 2006/10/26 19:47:24 ticho Exp $

inherit eutils perl-module

IRSSI_PV=0.8.9

DESCRIPTION="A SILC plugin for Irssi"
HOMEPAGE="http://penguin-breeder.org/silc/"
SRC_URI="http://irssi.org/files/irssi-${IRSSI_PV}.tar.bz2
	http://silcnet.org/download/client/sources/silc-client-${PV}.tar.gz
	http://penguin-breeder.org/silc/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="debug"

# All necessary dependencies are pulled in by irssi.
DEPEND="virtual/libc
	=dev-libs/glib-1.2*
	www-client/lynx"    # this is for .html -> .txt docs convert
RDEPEND=">=net-irc/irssi-${IRSSI_PV}
	>=dev-perl/MIME-tools-5.413
	dev-perl/File-MMagic
	dev-perl/MailTools"

S_SILC="${S}/../silc-client-${PV}"
S_IRSSI="${S}/../irssi-${IRSSI_PV}"

src_compile() {

	echo
	einfo "Preparing silc-client\n"
	cd ${S_SILC}
	if has_version ">=net-irc/irssi-0.8.10_rc1" ; then
		sed -i -e "s:\"term_type\":\"term_charset\":" \
			irssi/src/silc/core/silc-servers.c
		sed -i -e "s:\"term_type\":\"term_charset\":" \
			irssi/src/fe-text/term.c
	fi
	econf --with-helpdir=${D}/usr/share/irssi/help/silc/ \
		--without-libtoolfix \
		--enable-static \
		`use_enable debug` || die "silc-client configure failed"
	( MAKEOPTS="" emake -C lib ) || die "silc-client's lib compilation failed"

	echo
	einfo "Patching irssi source for silc-plugin\n"
	cd ${S}
	epatch ${FILESDIR}/${PV}-branch-update.patch || die "${PV}-branch-update.patch failed"
	emake patch IRSSI=${S_IRSSI} SILC=${S_SILC} || die "patching irssi sources failed"

	cd ${S_IRSSI}

	# this tiny patch fixes a compile-time error (bug #67255)  - ticho
	epatch ${FILESDIR}/${PV}-gcc34.patch || die "${PV}-gcc34.patch failed"

	echo
	einfo "Configuring irssi\n"
	econf --sysconfdir=/etc || die "irssi configure failed"
	echo
	einfo "Compiling silc-plugin\n"
	emake -C src/perl || die "irssi's src/perl compilation failed"
	emake -C src/fe-common/silc || die "irssi's src/fe-common/silc compilation failed"
	emake -C src/silc/core || die "irssi's src/silc/core compilation failed"
}

src_install() {
	cd ${S_IRSSI}
	make -C src/perl/silc DESTDIR=${D} install || die "irssi's src/perl/silc installation failed"
	make -C src/fe-common/silc DESTDIR=${D} install || die "irssi's src/fe-common/silc installation failed"
	make -C src/silc/core install DESTDIR=${D} install ||  die "irssi's src/silc/core installation failed"

	cd ${S_SILC}
	make -C irssi/docs/help install || die "silc-client's helpfiles installation failed"

	cd ${S}
	insinto /usr/share/irssi/scripts
	doins scripts/*

	insinto /usr/share/irssi
	doins default.theme

	dodoc AUTHORS COPYING README USAGE

	fixlocalpod
}

pkg_postinst() {
	einfo "You can load the plugin with following command in Irssi:"
	einfo
	einfo "\t/LOAD silc"
	einfo
	einfo "It will automatically generate a new key pair for you. You will be asked to"
	einfo "enter a passphrase for this keypair twice. If you leave the passphrase"
	einfo "empty, your key will not be stored encrypted."
	einfo
	einfo "To make full use of silc-plugin, you should load the following perl scripts"
	einfo "into irssi:"
	einfo
	einfo "\t/SCRIPT LOAD silc"
	einfo "\t/SCRIPT LOAD silc-mime"
	einfo
	einfo "To connect to the SILCNet, you can use following command in Irssi:"
	einfo
	einfo "\t/CONNECT -silcnet SILCNet silc.silcnet.org"
	einfo
	einfo "Have fun."
}
