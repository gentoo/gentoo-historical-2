# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-oss/gst-plugins-oss-0.8.1.ebuild,v 1.1 2004/04/23 16:50:58 foser Exp $

inherit gst-plugins

KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa ~amd64 ~ia64 ~mips"

IUSE=""
# should we depend on a kernel (?)
DEPEND="virtual/kernel"
