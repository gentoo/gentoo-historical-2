# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jens Blaesche <mr.big@pc-trouble.de>
# /home/cvsroot/gentoo-x86/skel.build,v 1.7 2001/08/25 21:15:08 chadh Exp

MY_P=${P/gkrellm-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="a Reminder Plugin for Gkrellm"
SRC_URI="http://www.engr.orst.edu/~simonsen/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://www.engr.orst.edu/~simonsen/reminder"

DEPEND=">=app-admin/gkrellm-1.2.1"

src_compile() {
	make || die
}

src_install () {
	insinto /usr/lib/gkrellm/plugins
	doins reminder.so
	dodoc README ChangeLog COPYING 
}
