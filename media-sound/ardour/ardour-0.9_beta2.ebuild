# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-0.9_beta2.ebuild,v 1.1 2003/06/29 15:03:09 robh Exp $

IUSE="nls ardour-ksi"

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.sourceforge.net/"
SRC_URI="mirror://sourceforge/ardour/${P/_/}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

S="${WORKDIR}/${P/_/}"

DEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.0_rc7
	media-sound/jack-cvs
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=media-libs/libsndfile-1.0.4
	sys-libs/gdbm
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/libsamplerate-0.0.14
	>=media-libs/liblrdf-0.3.1
	>=dev-libs/libxml2-2.5.7
	=media-libs/libart_lgpl-2.3*"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {

	local myconf="--disable-dependency-tracking --enable-optimize"
	use nls || myconf="${myconf} --disable-nls"
	use ksi || myconf="${myconf} --disable-ksi"
	econf ${myconf} || die "configure failed"

	emake || die "parallel make failed"
}

src_install() {

	einstall || die "make install failed"

	dodoc AUTHORS CONTRIBUTORS COPYING ChangeLog FAQ INSTALL NEWS README TODO TRANSLATORS

}
