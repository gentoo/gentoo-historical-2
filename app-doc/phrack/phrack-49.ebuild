# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/phrack/phrack-49.ebuild,v 1.2 2003/02/13 06:33:51 vapier Exp $

MY_P=${PN}${PV}
DESCRIPTION="...a Hacker magazine by the community, for the community...."
HOMEPAGE="http://www.phrack.org/"
SRC_URI="http://www.phrack.org/archives/${MY_P}.tar.gz"

LICENSE="phrack"
SLOT="${PV}"
KEYWORDS="x86"

S=${WORKDIR}/${MY_P}

src_install() {
	[ -d ${S} ] || cd ${WORKDIR}/*
	insinto /usr/share/doc/${PN}
	gzip *
	doins *
}
