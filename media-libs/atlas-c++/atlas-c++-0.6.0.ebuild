# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/atlas-c++/atlas-c++-0.6.0.ebuild,v 1.5 2007/07/21 23:24:35 nyhm Exp $

inherit eutils

MY_PN="Atlas-C++"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Atlas protocol, used in role playing games at worldforge."
HOMEPAGE="http://www.worldforge.org/dev/eng/libraries/atlas_cpp"
SRC_URI="mirror://sourceforge/worldforge/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bzip2 doc zlib"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
	    $(use_enable zlib) \
	    $(use_enable bzip2 bzlib) \
	    || die "Error: econf failed!"
	emake || die "Error: emake failed!"
	if use doc; then
		emake docs ||  die "Error: emake failed!"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	use doc && dohtml -r doc/html/*
	use doc && doman doc/man/*
	dodoc AUTHORS ChangeLog HACKING NEWS README ROADMAP THANKS TODO
}
