# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/eselect-mode/eselect-mode-1.3.8.ebuild,v 1.8 2013/09/05 13:26:34 ago Exp $

EAPI=5

inherit elisp

MY_P="eselect-${PV}"
DESCRIPTION="Emacs major mode for editing eselect files"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Eselect"
SRC_URI="mirror://gentoo/${MY_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

S="${WORKDIR}/${MY_P}/misc"
SITEFILE="50${PN}-gentoo.el"
