# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-oss/gst-plugins-oss-0.8.7.ebuild,v 1.3 2005/03/08 20:00:50 foser Exp $

inherit gst-plugins

KEYWORDS="x86 ~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc"
IUSE=""

# should we depend on a kernel (?)
DEPEND="virtual/os-headers"
