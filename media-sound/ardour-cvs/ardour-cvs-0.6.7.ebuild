# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour-cvs/ardour-cvs-0.6.7.ebuild,v 1.3 2003/09/11 01:21:31 msterret Exp $

IUSE="nls ardour-ksi"

inherit cvs

ECVS_SERVER="cvs.ardour.sourceforge.net:/cvsroot/ardour"
ECVS_MODULE="ardour"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/ardour"

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.sourceforge.net/"
SRC_URI="mirror://sourceforge/ardour/ardour-pixmaps-2.6.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="$DEPEND
	dev-util/pkgconfig
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

S="${WORKDIR}/${PN/-cvs/}"

src_compile() {

	local myconf="--disable-dependency-tracking"
	export WANT_AUTOCONF_2_5=1
	sh autogen.sh
	use nls || myconf="${myconf} --disable-nls"
	use ksi || myconf="${myconf} --disable-ksi"
	econf ${myconf} || die "configure failed"

	emake || die "parallel make failed"
}

src_install() {

	einstall || die "make install failed"

	pushd ${WORKDIR}
	mkdir pixmaps
	cd pixmaps
	unpack ${DISTFILES}/ardour-pixmaps-2.6.tar.bz2
	dodir /usr/share/ardour/pixmaps
	cp * ${D}/usr/share/ardour/pixmaps
	popd

	insinto /usr/share/ardour

	cp ardour.rc ardour.rc~
	sed -e 's:/usr/local/music/src/ardour/:/usr/share/ardour/:' \
	    -e 's:/home/paul/:/usr/share/ardour/:' ardour.rc~ > ardour.rc
	cp ardour.rc sample_ardour.rc

	cp ardour_ui.rc sample_ardour_ui.rc

	cp ardour_system.rc ardour_system.rc~
	sed -e 's:/usr/local/music/src/ardour/:/usr/share/ardour/:' ardour_system.rc~ > ardour_system.rc

	doins ${S}/ardour_system.rc

	dodoc ${S}/AUTHORS ${S}/INSTALL ${S}/README ${S}/README.it \
		${S}/NEWS ${S}/COPYING ${S}/ChangeLog ${S}/sample_ardour.rc \
		${S}/FAQ ${S}/sample_ardour_ui.rc
	doman ${S}/ardour.1
}

pkg_postinst() {
	einfo ""
	einfo "ardour-cvs depends on jack-cvs"
	einfo "make sure to re-emerge jack-cvs before re-emerging ardour-cvs"
	einfo "as the development of both programs are closely linked."
	einfo ""
	einfo "to get ardour to run you will need to copy the files sample_ardour.rc"
	einfo "and sample_ardour_ui.rc from /usr/share/doc/${P}/ to your homedirectory"
	einfo "(dropping the 'sample_' from the name :)"
	einfo "and set three environment variables."
	einfo "ARDOUR_RC should point to your where-ever you put your ardour.rc file"
	einfo "ARDOUR_SYSTEM_RC should point to /usr/share/ardour/ardour_system.rc"
	einfo "ARDOUR_UI_RC should point to where-ever you put your ardour_ui.rc file"
	einfo ""
}
