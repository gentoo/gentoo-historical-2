# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Log/PEAR-Log-1.8.4.ebuild,v 1.4 2004/12/27 16:54:43 vapier Exp $

inherit php-pear

DESCRIPTION="The Log framework provides an abstracted logging system supporting logging to console, file, syslog, SQL, and mcal targets."

LICENSE="PHP"
SLOT="0"
KEYWORDS="~x86 ~sparc ~alpha ~ppc ~ia64 ~amd64 ~hppa"
IUSE="pear-db"

DEPEND="pear-db? ( dev-php/PEAR-DB )"
