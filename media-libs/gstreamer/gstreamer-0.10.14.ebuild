# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gstreamer/gstreamer-0.10.14.ebuild,v 1.6 2007/09/09 16:57:33 opfer Exp $

inherit eutils libtool

# Create a major/minor combo for our SLOT and executables suffix
PVP=(${PV//[-\._]/ })
PV_MAJ_MIN=${PVP[0]}.${PVP[1]}
#PV_MAJ_MIN=0.10

DESCRIPTION="Streaming media framework"
HOMEPAGE="http://gstreamer.sourceforge.net"
SRC_URI="http://gstreamer.freedesktop.org/src/gstreamer/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT=${PV_MAJ_MIN}
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.8
	>=dev-libs/libxml2-2.4.9"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.11.5
	dev-util/pkgconfig"
#	dev-util/gtk-doc
#	=app-text/docbook-xml-dtd-4.2*"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix from upstream. Is included in next release.
	epatch "${FILESDIR}"/${P}-gstcaps.patch

	# Needed for sane .so versioning on Gentoo/FreeBSD
	elibtoolize
}

src_compile() {
	econf --disable-docs-build --with-package-name="Gentoo GStreamer Ebuild"  --with-package-origin="http://www.gentoo.org" || die
	emake -j1 || die "compile failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	# remove the unversioned binaries gstreamer provide
	# this is to prevent these binaries to be owned by several SLOTs
	cd "${D}"/usr/bin
	local gst_bins
	for gst_bins in $(ls *-${PV_MAJ_MIN}) ; do
		rm ${gst_bins/-${PV_MAJ_MIN}/}
		einfo "Removed ${gst_bins/-${PV_MAJ_MIN}/}"
	done

	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README RELEASE TODO

	echo "PRELINK_PATH_MASK=/usr/lib/${PN}-${PV_MAJ_MIN}" > 60${PN}-${PV_MAJ_MIN}
	doenvd 60${PN}-${PV_MAJ_MIN}
}

pkg_postinst() {
	elog "Gstreamer has known problems with prelinking, as a workaround"
	elog "this ebuild adds the gstreamer plugins to the prelink mask"
	elog "path to stop them from being prelinked. It is imperative"
	elog "that you undo & redo prelinking after building this pack for"
	elog "this to take effect. Make sure the gstreamer lib path is indeed"
	elog "added to the PRELINK_PATH_MASK environment variable."
	elog "For more information see http://bugs.gentoo.org/81512"
}
