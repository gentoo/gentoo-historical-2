# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-0.9_beta3.ebuild,v 1.3 2003/09/16 13:55:51 tigger Exp $

IUSE="nls ardour-ksi"

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.sourceforge.net/"
SRC_URI="mirror://sourceforge/ardour/${P/_/}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

S="${WORKDIR}/${P/_/}"

# beta3 won't compile against jack 0.80.0 yet
# the cvs version does, so the next beta will

DEPEND="dev-util/pkgconfig
	virtual/jack
	!media-sound/jack-audio-connect-kit-0.80.0
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
	local myarch

	myarch=`get-flag -march`

	cd $S
	find -name configure |xargs sed -i "s/\\(-O6 -fomit-frame-pointer -ffast-math -fstrength-reduce -funroll-loops -fmove-all-movables\\)/\\1 ${myarch}/"
	sed -i "s/-D_REENTRANT -O6 -mcpu=i686 -march=i686 -fomit-frame-pointer -ffast-math -fstrength-reduce -fmove-all-movables/-D_REENTRANT -O6 ${myarch} -fomit-frame-pointer -ffast-math -fstrength-reduce -fmove-all-movables/" libs/ardour/configure
	use nls || myconf="${myconf} --disable-nls"
	use ardour-ksi || myconf="${myconf} --disable-ksi"
	econf ${myconf} || die "configure failed"

	emake || die "parallel make failed"
}

src_install() {

	einstall || die "make install failed"

	dodoc AUTHORS CONTRIBUTORS COPYING ChangeLog FAQ INSTALL NEWS README TODO TRANSLATORS

}
