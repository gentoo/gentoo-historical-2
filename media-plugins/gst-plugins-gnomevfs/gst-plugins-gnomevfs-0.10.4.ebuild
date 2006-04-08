# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gnomevfs/gst-plugins-gnomevfs-0.10.4.ebuild,v 1.6 2006/04/08 12:02:39 dertobi123 Exp $

inherit gst-plugins-base

KEYWORDS="amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.4
		 >=gnome-base/gnome-vfs-2"

DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="gnome_vfs"

src_unpack() {
	gst-plugins-base_src_unpack

	cd ${S}/ext/gnomevfs
	epatch ${FILESDIR}/gst-plugins-gnomevfs-0.10.4-fix.diff
}
