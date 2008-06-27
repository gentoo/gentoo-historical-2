# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/volume/volume-20070510.ebuild,v 1.1 2008/06/27 16:02:15 ulm Exp $

inherit elisp

DESCRIPTION="Tweak your sound card volume from Emacs"
HOMEPAGE="http://www.brockman.se/software/volume-el/"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

# NOTE we might define the following which volume.el can work with by
# default, but volume.el can really work with anything.

# RDEPEND="|| ( media-sound/aumixer media-sound/alsa-utils )"

SITEFILE=50${PN}-gentoo.el
