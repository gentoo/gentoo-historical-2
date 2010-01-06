# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/clusterssh/clusterssh-3.28.ebuild,v 1.2 2010/01/06 19:26:18 fauli Exp $

EAPI=2

DESCRIPTION="Concurrent Multi-Server Terminal Access."
HOMEPAGE="http://clusterssh.sourceforge.net"
SRC_URI="mirror://sourceforge/clusterssh/clusterssh-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1
	dev-perl/perl-tk
	dev-perl/Config-Simple
	dev-perl/X11-Protocol
	x11-apps/xlsfonts"
DEPEND="${RDEPEND}"

src_prepare() {
	# Gentoo perl ebuilds remove podchecker
	if grep -v podchecker "${S}"/src/Makefile.in \
		> "${S}"/src/Makefile.in.new; then
		mv "${S}"/src/Makefile.in.new "${S}"/src/Makefile.in
	else
		die "Makefile.in update failed"
	fi
}

src_install() {
	dobin src/cssh || die "dobin failed"
	doman src/cssh.1
	dodoc AUTHORS NEWS README THANKS
}
