# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-asdf-binary-locations/cl-asdf-binary-locations-20061018.ebuild,v 1.7 2008/04/29 17:57:30 ranger Exp $

inherit common-lisp

DESCRIPTION="An ASDF-Extension that makes it easy to specify where your Common Lisp binaries (FASL files) should go."
HOMEPAGE="http://common-lisp.net/project/cl-containers/asdf-binary-locations/"
SRC_URI="http://common-lisp.net/project/portage-overlay/distfiles/${PN/cl-/}_${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-lisp/cl-asdf"

S=${WORKDIR}/${PN/cl-/}

CLPACKAGE=asdf-binary-locations

src_install() {
	insinto $CLSOURCEROOT/$CLPACKAGE/dev
	doins dev/*.lisp
	common-lisp-install *.asd
	common-lisp-system-symlink
}
