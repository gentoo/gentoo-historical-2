# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/clusterssh/clusterssh-3.24.ebuild,v 1.2 2009/05/05 10:45:34 ssuominen Exp $

inherit eutils

DESCRIPTION="Concurrent Multi-Server Terminal Access."
HOMEPAGE="http://clusterssh.sourceforge.net"
SRC_URI="mirror://sourceforge/clusterssh/clusterssh-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1
	dev-perl/perl-tk
	dev-perl/Config-Simple
	dev-perl/X11-Protocol
	x11-apps/xlsfonts"
DEPEND="${RDEPEND}"

src_compile() {
	# Gentoo perl ebuilds remove podchecker
	if grep -v podchecker "${S}"/src/Makefile.in \
		> "${S}"/src/Makefile.in.new; then
		mv "${S}"/src/Makefile.in.new "${S}"/src/Makefile.in
	else
		die "Makefile.in update failed"
	fi

	econf || die "configuration failed"
	emake || die "compiling failed"
}

src_install() {
	dodoc AUTHORS INSTALL NEWS README THANKS
	dobin src/cssh
	doman src/cssh.1
}
