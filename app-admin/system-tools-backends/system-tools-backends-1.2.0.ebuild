# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/system-tools-backends/system-tools-backends-1.2.0.ebuild,v 1.3 2005/05/06 11:32:26 corsair Exp $

inherit gnome2

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://www.gnome.org/projects/gst/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~sparc ~x86 ~ppc64"
IUSE=""

RDEPEND="net-misc/openssh
	sys-apps/shadow
	>=dev-libs/libxml2-2.4.12
	!<app-admin/gnome-system-tools-1.1.91"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.29"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

USE_DESTDIR="1"
