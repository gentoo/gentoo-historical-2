# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-oss/gst-plugins-oss-0.8.1.ebuild,v 1.9 2004/11/08 18:08:04 vapier Exp $

inherit gst-plugins

KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ~sparc x86"
IUSE=""

# should we depend on a kernel (?)
DEPEND="virtual/os-headers"
