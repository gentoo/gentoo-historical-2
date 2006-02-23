# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/run-mailcap/run-mailcap-3.28_p1-r1.ebuild,v 1.8 2006/02/23 20:34:00 corsair Exp $

MY_PV="${PV/_p/-}"
DESCRIPTION="Execute programs via entries in the mailcap file"
HOMEPAGE="http://packages.debian.org/unstable/net/mime-support.html"
SRC_URI="mirror://debian/pool/main/m/mime-support/mime-support_${MY_PV}.tar.gz"
LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ~ppc64 sparc x86"
IUSE=""
DEPEND=""
RDEPEND=">=dev-lang/perl-5.6
	app-misc/mime-types"

S=${WORKDIR}/mime-support

src_compile() {
	sed -i run-mailcap -e 's:^\(\$xtermprgrm=\)"/usr/bin/x-terminal-emulator":\1$ENV{XTERMCMD} || "xterm":'
}

src_install() {
	dobin run-mailcap
	newman run-mailcap.man run-mailcap.1
	newman mailcap.man mailcap.4
	for i in compose edit see print; do
		( cd ${D}/usr/bin && ln -s run-mailcap $i )
		( cd ${D}/usr/share/man/man1 && ln -s run-mailcap.1 $i.1 )
	done
}
