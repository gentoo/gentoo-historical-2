# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k3b/k3b-0.11.12-r1.ebuild,v 1.6 2004/09/14 13:29:32 carlo Exp $

inherit kde

DESCRIPTION="K3b, KDE CD Writing Software"
HOMEPAGE="http://www.k3b.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc amd64"
IUSE="arts debug dvdr kde oggvorbis mad flac encode"

DEPEND="kde? ( >=kde-base/kdebase-3.1 )
	>=media-sound/cdparanoia-3.9.8
	>=media-libs/id3lib-3.8.0_pre2
	flac? ( media-libs/flac )
	mad? ( >=media-sound/madplay-0.14.2b )
	oggvorbis? ( media-libs/libvorbis )
	arts? ( kde-base/arts )"

RDEPEND="${DEPEND}
	virtual/cdrtools
	>=app-cdr/cdrdao-1.1.7-r3
	media-sound/normalize
	dvdr? ( app-cdr/dvd+rw-tools )
	encode? ( media-sound/lame
		  media-sound/sox
		  !amd64? ( <media-video/transcode-0.6.12 )
		  media-video/vcdimager )"
need-kde 3.1

# These are the languages supported by k3b as of version 0.11.6.
# If you are using this ebuild as a model for another ebuild for
# another version of K3b, DO check whether these values are different.
# Check the {po,doc}/Makefile.am files in k3b-i18n package.
LANGS="ar bg ca bs da de cs el es et fi fo fr gl hu ja it nb \
nl pl pt ro ru sk sl ta sr sv tr xh xx zu nso ven en_GB pt_BR \
zh_CN zh_TW"

# Documentation packages are less (in general they may contain
# other packages too,  not in this case)
LANGS_DOC="da de es et fr pt ru sv"

I18N="${PN}-i18n-${PV%.*}"

for pkg in ${LANGS}
do
	SRC_URI="${SRC_URI} linguas_${pkg}? ( mirror://sourceforge/k3b/${I18N}.tar.bz2 )"
done

src_compile() {
	local _S=${S}
	local myconf="--enable-libsuffix="

	use debug && myconf="${myconf} --enable-debugging --enable-profiling" \
		|| myconf="${myconf} --disable-debugging --disable-profiling"
	use kde || myconf="${myconf} --without-k3bsetup"
	use arts || myconf="${myconf} --without-arts"

	# Build process of K3B
	kde_src_compile

	# Build process of K3B-i18n, select LINGUAS elements
	S=${WORKDIR}/${I18N}
	if [ -n "${LINGUAS}" -a -d "${S}" ]; then
		MAKE_PO="SUBDIRS = "
		for lang in ${LANGS}
		do
			use linguas_${lang} && MAKE_PO="${MAKE_PO} ${lang}"
		done
		sed -i -e "s:^SUBDIRS = .*:${MAKE_PO}:" ${S}/po/Makefile.in

		MAKE_DOC="SUBDIRS = "
		for langdoc in ${LANGS_DOC}
		do
			use linguas_${langdoc} && MAKE_DOC="${MAKE_DOC} ${langdoc}"
		done
		sed -i -e "s:^SUBDIRS = .*:${MAKE_DOC}:" ${S}/doc/Makefile.in

		kde_src_compile
	fi
	S=${_S}
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog FAQ README TODO

	if [ -n "${LINGUAS}" -a -d "${WORKDIR}/${I18N}" ]; then
		cd ${WORKDIR}/${I18N}
		make DESTDIR=${D} install || die
	fi

	# install menu entry and icon
	dodir /usr/share/applications
	mv ${D}/usr/share/applnk/Multimedia/k3b.desktop ${D}/usr/share/applications
	if use kde; then
		mv ${D}/usr/share/applnk/Settings/System/k3bsetup2.desktop ${D}/usr/share/applications
	fi
	rm -fR ${D}/usr/share/applnk/
	dodir /usr/share/pixmaps
	cp ${D}/usr/share/icons/crystalsvg/32x32/apps/k3b.png ${D}/usr/share/pixmaps/
}

pkg_postinst() {
	einfo "Note that k3b will report problems regarding the permissions of cdrecord"
	einfo "and cdrdao, and will suggest some changes for your system. You are free"
	einfo "to follow those advices, note nonetheless that on a default Gentoo install"
	einfo "k3b should run fine when you are in the cdrom and cdrw group."
}
