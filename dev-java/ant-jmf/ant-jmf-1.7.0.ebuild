# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-jmf/ant-jmf-1.7.0.ebuild,v 1.1 2007/01/21 23:06:42 caster Exp $

inherit ant-tasks

KEYWORDS="~x86"

src_unpack() {
	# seems no need to dep on jmf-bin, the classes ant imports are in J2SE API since 1.3
	ant-tasks_src_unpack base
}
