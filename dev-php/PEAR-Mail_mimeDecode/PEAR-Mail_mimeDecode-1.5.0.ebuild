# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Mail_mimeDecode/PEAR-Mail_mimeDecode-1.5.0.ebuild,v 1.9 2007/12/06 00:37:56 jokey Exp $

inherit php-pear-r1 eutils

DESCRIPTION="Provides a class to decode mime messages (split from PEAR-Mail_Mime)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

# >=PEAR-Mail_Mime-1.5.2 in in DEPEND to avoid blockers and circular deps
# with this package; using PDEPEND in PEAR-Mail_Mime for the same reason

DEPEND=">=dev-php/PEAR-PEAR-1.6.0
	>=dev-php/PEAR-Mail_Mime-1.5.2"
