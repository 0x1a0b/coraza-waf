// Copyright 2020 Juan Pablo Tosso
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package operators

import (
	"context"
	"github.com/jptosso/coraza-waf/pkg/engine"
	"os/exec"
	"time"
)

type InspectFile struct {
	path string
}

func (o *InspectFile) Init(data string) {
	o.path = data
}

func (o *InspectFile) Evaluate(tx *engine.Transaction, value string) bool {
	//TODO parametrize timeout
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	//Add /bin/bash to context?
	cmd := exec.CommandContext(ctx, o.path, value)
	_, err := cmd.CombinedOutput()
	if ctx.Err() == context.DeadlineExceeded || err != nil {
		return false
	}
	return true
}
