# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-dev-tools/xfce4-dev-tools-4.4.0.ebuild,v 1.3 2007/02/26 19:56:51 drac Exp $

inherit xfce44

xfce44

DESCRIPTION="m4macros for autotools eclass and subversion builds"
HOMEPAGE="http://foo-projects.org/~benny/projects/xfce4-dev-tools"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=""
DEPEND=""

DOCS="AUTHORS ChangeLog HACKING NEWS README"

xfce44_core_package
