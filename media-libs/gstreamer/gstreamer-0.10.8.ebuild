# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gstreamer/gstreamer-0.10.8.ebuild,v 1.11 2006/09/04 03:48:43 kumba Exp $

inherit eutils flag-o-matic libtool flag-o-matic

# Create a major/minor combo for our SLOT and executables suffix
PVP=(${PV//[-\._]/ })
PV_MAJ_MIN=${PVP[0]}.${PVP[1]}
#PV_MAJ_MIN=0.10

DESCRIPTION="Streaming media framework"
HOMEPAGE="http://gstreamer.sourceforge.net"
SRC_URI="http://gstreamer.freedesktop.org/src/gstreamer/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT=${PV_MAJ_MIN}
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

RDEPEND=">=dev-libs/glib-2.8
	>=dev-libs/libxml2-2.4.9"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.11.5
	dev-util/pkgconfig"
#	dev-util/gtk-doc
#	=app-text/docbook-xml-dtd-4.2*"

src_compile() {
	econf --disable-docs-build

	make || die "compile failed"

}

src_install() {

	make DESTDIR=${D} install || die

	# remove the unversioned binaries gstreamer provide
	# this is to prevent these binaries to be owned by several SLOTs
	cd ${D}/usr/bin
	for gst_bins in `ls *-${PV_MAJ_MIN}`
	do
		rm ${gst_bins/-${PV_MAJ_MIN}/}
		einfo "Removed ${gst_bins/-${PV_MAJ_MIN}/}"
	done

	cd ${S}
	dodoc AUTHORS ChangeLog COPYING* DEVEL \
		NEWS README RELEASE REQUIREMENTS TODO

	dodir /etc/env.d/
	echo "PRELINK_PATH_MASK=/usr/lib/${PN}-${PV_MAJ_MIN}" > ${D}/etc/env.d/60${PN}-${PV_MAJ_MIN}

}

pkg_postinst() {

	einfo "Gstreamer has known problems with prelinking, as a workaround"
	einfo "this ebuild adds the gstreamer plugins to the prelink mask"
	einfo "path to stop them from being prelinked. It is imperative"
	einfo "that you undo & redo prelinking after building this pack for"
	einfo "this to take effect. Make sure the gstreamer lib path is indeed"
	einfo "added to the PRELINK_PATH_MASK environment variable."
	einfo "For more information see http://bugs.gentoo.org/show_bug.cgi?id=81512"

}
