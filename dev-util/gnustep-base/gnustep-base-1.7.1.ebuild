# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gnustep-base/gnustep-base-1.7.1.ebuild,v 1.2 2003/07/26 08:51:52 raker Exp $

IUSE=""

inherit gnustep

DESCRIPTION="GNUstep base package"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-x86 -ppc -sparc"

DEPEND="=dev-util/gnustep-make-${PV}*
	>=dev-libs/libxml2-2.4.24"

src_compile() {
	egnustepmake \
		--with-xml-prefix=/usr \
		--with-gmp-include=/usr/include \
		--with-gmp-library=/usr/lib || die "./configure failed"
}

src_install() {
	egnustepinstall
	exeinto /etc/init.d ; newexe ${FILESDIR}/gnustep gnustep
}

pkg_postinst() {
	einfo "You should set the local timezone and language with the defaults command now."
	einfo
	einfo "i.e. \"defaults write NSGlobalDomain \"Local Time Zone\" America/Chicago\""
	einfo "     \"defaults write NSGlobalDomain NSLanguages \"English\"\""
	einfo
	einfo "Time zones can be found in"
	einfo "  /usr/GNUstep/System/Libraries/Resources/NSTimeZones/zones/"
	einfo
	einfo "Make sure that you type"
	einfo "  \". /usr/GNUstep/System/Makefiles/GNUstep.sh\" first to set the right PATH"
	einfo
	einfo "For GNUstep to work properly \"gnustep\" should be added to your default"
	einfo "  runlevel.  This can be done by typing \"rc-update add gnustep default\"."
}
