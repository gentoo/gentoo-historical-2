# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-WorkflowDatabaseTiein/ezc-WorkflowDatabaseTiein-1.0.ebuild,v 1.3 2007/10/08 19:02:05 jokey Exp $

inherit php-ezc

DESCRIPTION="This eZ component contains the database backend for the Workflow component."
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	>=dev-php5/ezc-Workflow-1.0.1
	>=dev-php5/ezc-Database-1.3"
