# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-oss/gst-plugins-oss-0.8.1.ebuild,v 1.7 2004/06/24 23:30:56 agriffis Exp $

inherit gst-plugins

KEYWORDS="x86 ppc ~alpha ~sparc hppa amd64 ~ia64 mips"

IUSE=""
# should we depend on a kernel (?)
DEPEND="virtual/kernel"
