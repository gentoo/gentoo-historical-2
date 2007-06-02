# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/gnus/gnus-0.ebuild,v 1.2 2007/06/02 17:42:24 ulm Exp $

DESCRIPTION="Virtual for the Gnus newsreader"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/emacs/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
# remove emacs-cvs when virtual/emacs-22 has all of its keywords
RDEPEND="|| (
	>=app-emacs/gnus-5.10.8
	>=app-emacs/gnus-cvs-5.11
	>=virtual/emacs-22
	>=app-editors/emacs-cvs-22
	)"
