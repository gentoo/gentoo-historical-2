# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted/twisted-2.0.0.ebuild,v 1.4 2005/05/05 23:07:49 swegener Exp $

inherit distutils

# for alphas,..
MY_PV="${PV/_alpha/a}"
MY_PN="Twisted"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="collection of servers and clients, which can be used either by developers of new applications or directly. Documentation included."
HOMEPAGE="http://www.twistedmatrix.com/"
SRC_URI="http://tmrc.mit.edu/mirror/twisted/${MY_PN}/2.0/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"
IUSE="gtk gtk2 doc"

DEPEND=">=dev-lang/python-2.2
	>=dev-python/pycrypto-1.9_alpha6
	dev-python/pyserial
	dev-python/pyopenssl
	gtk2? ( >=dev-python/pygtk-1.99 )
	net-zope/zopeinterface"
#	doc? ( =dev-python/twisted-docs-${PV} )"

S=${WORKDIR}/${MY_P}

