# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opus/opus-0.9.8.ebuild,v 1.1 2011/11/19 16:16:02 lu_zero Exp $

EAPI=4

if [[ ${PV} == *9999 ]] ; then
	SCM="git-2"
	EGIT_REPO_URI="git://git.opus-codec.org/opus.git"
fi

inherit autotools ${SCM}

DESCRIPTION="The Opus codec is designed for interactive speech and audio
transmission over the Internet."
HOMEPAGE="http://opus-codec.org/"
SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"
if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
elif [[ ${PV%_p*} != ${PV} ]] ; then # Gentoo snapshot
	SRC_URI="http://dev.gentoo.org/~lu_zero/${PN}/${P}.tar.xz"
else # Official release
	SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	myconf="--enable-custom-modes"

	econf $(use_enable doc) ${myconf}
}

src_compile() {
	default
}

src_install() {
	default
	find "${D}" -name '*.la' -delete
	rm -fR "${D}/usr/share/doc/opus"
	use doc && dohtml -r doc/html/*
}
