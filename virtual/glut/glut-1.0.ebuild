# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/glut/glut-1.0.ebuild,v 1.3 2006/07/06 08:32:20 flameeyes Exp $

DESCRIPTION="Virtual for OpenGL utility toolkit"
HOMEPAGE="http://www.gentoo.org/proj/en/desktop/x/x11/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND="|| ( media-libs/freeglut media-libs/glut )"
DEPEND="${RDEPEND}"
