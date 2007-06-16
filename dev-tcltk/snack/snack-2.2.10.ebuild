# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/snack/snack-2.2.10.ebuild,v 1.8 2007/06/16 02:38:04 angelos Exp $

inherit eutils multilib

DESCRIPTION="The Snack Sound Toolkit (Tcl)"
HOMEPAGE="http://www.speech.kth.se/snack/"
SRC_URI="http://www.speech.kth.se/snack/dist/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 sparc x86"
SLOT="0"
IUSE="alsa python threads vorbis"

RESTRICT="test" # Bug 78354

DEPEND=">dev-lang/tcl-8.4.3
	>dev-lang/tk-8.4.3
	alsa? ( media-libs/alsa-lib )
	vorbis? ( media-libs/libvorbis )
	python? ( virtual/python )"

S="${WORKDIR}/${PN}${PV}/unix"

src_compile() {
	local myconf="--libdir=/usr/$(get_libdir) --includedir=/usr/include"

	use alsa && myconf="${myconf} --enable-alsa"
	use threads && myconf="${myconf} --enable-threads"

	if use vorbis ; then
		myconf="${myconf} --with-ogg-include=${ROOT}/usr/include"
		myconf="${myconf} --with-ogg-lib=${ROOT}/usr/$(get_libdir)"
	fi

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	if use python ; then
		cd "${S}"/../python
		python setup.py install --root="${D}" || die
	fi

	cd "${S}"/..

	dodoc README changes
	dohtml doc/*
}
